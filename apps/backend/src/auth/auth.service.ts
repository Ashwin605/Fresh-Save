/* eslint-disable @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unused-vars */
import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as argon2 from 'argon2';
import * as crypto from 'crypto';
import { PrismaService } from '../database/prisma/prisma.service';
import { MailService } from '../mail/mail.service';
import { RegisterDto } from './dto/register.dto';
import { RegisterBusinessDto } from './dto/register-business.dto';
import { LoginDto } from './dto/login.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { UserRole, UserStatus } from '@prisma/client';
import { RedisService } from '../redis/redis.service';

export interface JwtPayload {
  sub: string; // userId
  role: string;
  sessionId: string;
}

/**
 * AuthService handles all business logic related to user authentication,
 * including verifying credentials, generating JWT tokens, and managing refresh tokens.
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private mailService: MailService,
    private redisService: RedisService,
  ) {}

  async register(registerDto: RegisterDto) {
    const { name, email, phone, password } = registerDto;
    const normalizedEmail = email.toLowerCase().trim();

    // Check if user exists
    const existingUser = await this.prisma.user.findFirst({
      where: {
        OR: [{ email: normalizedEmail }, ...(phone ? [{ phone }] : [])],
      },
    });

    if (existingUser) {
      if (existingUser.email === normalizedEmail) {
        throw new ConflictException('Email already in use');
      }
      throw new ConflictException('Phone already in use');
    }

    const hashedPassword = await argon2.hash(password);

    const user = await this.prisma.user.create({
      data: {
        name,
        email: normalizedEmail,
        phone,
        password: hashedPassword,
        role: UserRole.CUSTOMER, // Always default to CUSTOMER
      },
    });

    // Strip sensitive info
    const { password: _ignored, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  async registerBusiness(dto: RegisterBusinessDto) {
    const { ownerName, email, phone, password, businessName, storeName, storeAddress } = dto;
    const normalizedEmail = email.toLowerCase().trim();

    // Check if user exists
    const existingUser = await this.prisma.user.findFirst({
      where: {
        OR: [{ email: normalizedEmail }, ...(phone ? [{ phone }] : [])],
      },
    });

    if (existingUser) {
      if (existingUser.email === normalizedEmail) {
        throw new ConflictException('Email already in use');
      }
      throw new ConflictException('Phone already in use');
    }

    const hashedPassword = await argon2.hash(password);

    // Run in a transaction
    const user = await this.prisma.$transaction(async (tx) => {
      // 1. Create User as SHOP_OWNER
      const newUser = await tx.user.create({
        data: {
          name: ownerName,
          email: normalizedEmail,
          phone,
          password: hashedPassword,
          role: UserRole.SHOP_OWNER,
        },
      });

      // 2. Create Business
      const business = await tx.business.create({
        data: {
          ownerId: newUser.id,
          businessName: businessName,
        },
      });

      // 3. Create Store
      const store = await tx.store.create({
        data: {
          businessId: business.id,
          name: storeName,
          address: storeAddress,
          latitude: dto.latitude,
          longitude: dto.longitude,
        },
      });

      // 4. Update Geography Location
      if (dto.latitude && dto.longitude) {
        await tx.$executeRawUnsafe(`
          UPDATE "Store" 
          SET location = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography 
          WHERE id = $3
        `, dto.longitude, dto.latitude, store.id);
      }

      return newUser;
    });

    // Strip sensitive info
    const { password: _ignored, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  /**
   * Authenticates a user based on their email and password.
   * 
   * Authentication Flow:
   * 1. Finds the user by their normalized email address.
   * 2. Checks if the user is suspended or deleted.
   * 3. Uses argon2 to verify the provided password against the hashed password.
   * 4. Generates new access and refresh tokens.
   * 5. Saves the new refresh token (session) in the database.
   * 
   * @param loginDto - Contains the email, password, and optional deviceInfo.
   * @param userAgent - User agent string for session tracking.
   * @returns An object containing the user profile (without password) and tokens.
   * @throws UnauthorizedException if credentials are invalid.
   */
  async login(loginDto: LoginDto, userAgent?: string) {
    const startTime = Date.now();
    this.logger.debug(`[AUTH] Login request received for email: ${loginDto.email}`);

    const { email, password } = loginDto;
    const normalizedEmail = email.toLowerCase().trim();

    const t1 = Date.now();
    const user = await this.prisma.user.findUnique({
      where: { email: normalizedEmail },
    });
    this.logger.debug(`[AUTH] Prisma user lookup took: ${Date.now() - t1}ms`);

    if (!user || !user.password) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (user.status !== UserStatus.ACTIVE) {
      throw new ForbiddenException(`Account is ${user.status.toLowerCase()}`);
    }

    const t2 = Date.now();
    const isPasswordValid = await argon2.verify(user.password, password);
    this.logger.debug(`[AUTH] Argon2 verification took: ${Date.now() - t2}ms`);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const t3 = Date.now();
    const tokens = await this.generateTokens(user.id, user.role, userAgent);
    this.logger.debug(`[AUTH] Token generation took: ${Date.now() - t3}ms`);

    const { password: _ignoredPass, ...userWithoutPassword } = user;
    
    this.logger.debug(`[AUTH] Total login execution took: ${Date.now() - startTime}ms`);
    return {
      user: userWithoutPassword,
      ...tokens,
    };
  }

  /**
   * Refreshes a user's access token using a valid refresh token.
   * 
   * Rotation Flow:
   * 1. Validates the provided refresh token's signature and expiry.
   * 2. Extracts the userId and sessionId from the token payload.
   * 3. Finds the active session in the database.
   * 4. If the session is already revoked, ALL user sessions are revoked (security measure against reuse).
   * 5. Revokes the old session to prevent reuse.
   * 6. Generates new access and refresh tokens.
   * 
   * @param refreshTokenDto - Contains the refresh token sent by the client.
   * @param userAgent - Optional device information for the new session.
   * @returns An object containing the user profile and the new tokens.
   * @throws UnauthorizedException if the token is invalid, expired, or revoked.
   */
  async refresh(refreshTokenDto: RefreshTokenDto, userAgent?: string) {
    const { refreshToken } = refreshTokenDto;

    try {
      // Verify signature and expiration
      const payload = await this.jwtService.verifyAsync(refreshToken, {
        secret: this.configService.get<string>('jwt.refreshSecret'),
      });

      const { sub: userId, sessionId } = payload;

      const session = await this.prisma.session.findUnique({
        where: { id: sessionId },
      });

      if (!session) {
        throw new UnauthorizedException('Session not found');
      }

      if (session.isRevoked) {
        // Token reuse detected on a revoked session!
        // Invalidate ALL user sessions as a security measure
        await this.prisma.session.updateMany({
          where: { userId },
          data: { isRevoked: true },
        });
        this.logger.warn(
          `Refresh token reuse detected for user ${userId}. All sessions revoked.`,
        );
        throw new UnauthorizedException('Session has been revoked');
      }

      // Verify the refresh token
      // 1. Check if it's the new SHA256 format
      const hashedProvidedToken = crypto
        .createHash('sha256')
        .update(refreshToken)
        .digest('hex');
        
      let isTokenValid = false;
      
      if (session.refreshToken === hashedProvidedToken) {
        isTokenValid = true;
      } else if (session.refreshToken.startsWith('$argon2')) {
        // Fallback to Argon2 for backwards compatibility with existing sessions
        isTokenValid = await argon2.verify(
          session.refreshToken,
          refreshToken,
        );
      }

      if (!isTokenValid) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      // User check
      const user = await this.prisma.user.findUnique({ where: { id: userId } });
      if (!user || user.status !== UserStatus.ACTIVE) {
        throw new UnauthorizedException('User inactive or not found');
      }

      // Rotate token: Revoke old session and issue new tokens
      await this.prisma.session.update({
        where: { id: sessionId },
        data: { isRevoked: true },
      });

      return this.generateTokens(user.id, user.role, userAgent);
    } catch {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }
  }

  /**
   * Logs out a user by revoking their current session.
   * 
   * Flow:
   * 1. Marks the session associated with the provided ID as revoked in the database.
   * This ensures the refresh token can no longer be used to generate new access tokens.
   * 
   * @param sessionId - The ID of the session to revoke.
   */
  async logout(sessionId: string) {
    if (!sessionId) return;
    try {
      await this.prisma.session.update({
        where: { id: sessionId },
        data: { isRevoked: true },
      });
    } catch {
      // Ignore if session not found
    }
  }

  async changePassword(
    userId: string,
    changePasswordDto: ChangePasswordDto,
    currentSessionId: string,
  ) {
    const { currentPassword, newPassword } = changePasswordDto;

    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user || !user.password) {
      throw new UnauthorizedException('Invalid user');
    }

    const isPasswordValid = await argon2.verify(user.password, currentPassword);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid current password');
    }

    const newHashedPassword = await argon2.hash(newPassword);

    await this.prisma.user.update({
      where: { id: userId },
      data: { password: newHashedPassword },
    });

    // Invalidate all OTHER sessions so user must log in again on other devices
    await this.prisma.session.updateMany({
      where: {
        userId,
        id: { not: currentSessionId },
      },
      data: { isRevoked: true },
    });
  }

  async forgotPassword(email: string) {
    const normalizedEmail = email.toLowerCase().trim();

    // 1. Enforce 60-second cooldown per email
    const cooldownKey = `forgot-password:cooldown:${normalizedEmail}`;
    // NX: Set only if it does not exist. EX: Expire after 60 seconds.
    const isCooldown = await this.redisService.getClient().set(cooldownKey, '1', 'EX', 60, 'NX');
    if (!isCooldown) {
      return { message: 'If an account exists, a reset link was sent.' };
    }

    const user = await this.prisma.user.findUnique({
      where: { email: normalizedEmail },
    });

    if (!user) {
      // Return success anyway to prevent email enumeration
      return { message: 'If an account exists, a reset link was sent.' };
    }

    // Generate 6-digit OTP securely
    const otp = crypto.randomInt(100000, 1000000).toString();
    const hashedOtp = await argon2.hash(otp);

    // Set expiry to 15 mins from now
    const expires = new Date();
    expires.setMinutes(expires.getMinutes() + 15);

    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        resetPasswordToken: hashedOtp,
        resetPasswordExpires: expires,
      },
    });

    // Reset failed attempt counter for the new cycle
    const attemptKey = `reset-password:attempts:${user.id}`;
    await this.redisService.getClient().del(attemptKey);

    await this.mailService.sendPasswordResetEmail(user.email, otp);

    return { message: 'If an account exists, a reset link was sent.' };
  }

  async resetPassword(email: string, otp: string, newPassword: string) {
    const normalizedEmail = email.toLowerCase().trim();
    const user = await this.prisma.user.findUnique({
      where: { email: normalizedEmail },
    });

    if (!user || !user.resetPasswordToken || !user.resetPasswordExpires) {
      throw new UnauthorizedException('Invalid or expired reset token');
    }

    if (new Date() > user.resetPasswordExpires) {
      throw new UnauthorizedException('Reset token has expired');
    }

    const attemptKey = `reset-password:attempts:${user.id}`;
    const isValid = await argon2.verify(user.resetPasswordToken, otp);
    
    if (!isValid) {
      const attempts = await this.redisService.getClient().incr(attemptKey);
      if (attempts === 1) {
        // Set TTL to 15 minutes, matching the maximum OTP lifetime
        await this.redisService.getClient().expire(attemptKey, 900);
      }
      
      if (attempts >= 5) {
        // Lockout: Invalidate OTP in DB
        await this.prisma.user.update({
          where: { id: user.id },
          data: {
            resetPasswordToken: null,
            resetPasswordExpires: null,
          }
        });
        await this.redisService.getClient().del(attemptKey);
        throw new UnauthorizedException('Maximum attempts reached. Token invalidated.');
      }
      
      throw new UnauthorizedException('Invalid reset token');
    }
    
    // Clear attempt counter on success
    await this.redisService.getClient().del(attemptKey);

    const newHashedPassword = await argon2.hash(newPassword);

    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        password: newHashedPassword,
        resetPasswordToken: null,
        resetPasswordExpires: null,
      },
    });

    // Invalidate all existing sessions
    await this.prisma.session.updateMany({
      where: { userId: user.id },
      data: { isRevoked: true },
    });

    return { message: 'Password has been successfully reset' };
  }

  private async generateTokens(
    userId: string,
    role: string,
    deviceInfo?: string,
  ) {
    // We generate the session record FIRST to get the sessionId
    // But we need the refresh token hash to store in the DB.
    // Solution: Create an empty session, generate token with its ID, hash token, update session.
    // Or generate a random string, use it as JTI.

    // Create initial session with dummy token
    const session = await this.prisma.session.create({
      data: {
        userId,
        refreshToken: '',
        expiresAt: new Date(), // temporary
        deviceInfo,
      },
    });

    const accessPayload: JwtPayload = {
      sub: userId,
      role,
      sessionId: session.id,
    };
    const refreshPayload = { sub: userId, sessionId: session.id };

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(accessPayload, {
        secret: this.configService.get<string>('jwt.accessSecret'),
        expiresIn: this.configService.get<string>(
          'jwt.accessExpiration',
        ) as any,
      }),
      this.jwtService.signAsync(refreshPayload, {
        secret: this.configService.get<string>('jwt.refreshSecret'),
        expiresIn: this.configService.get<string>(
          'jwt.refreshExpiration',
        ) as any,
      }),
    ]);

    // Parse expiration from the generated refresh token
    const decodedRefresh = this.jwtService.decode(refreshToken);
    const expiresAt = new Date(decodedRefresh.exp * 1000);

    const hashedRefreshToken = crypto
      .createHash('sha256')
      .update(refreshToken)
      .digest('hex');

    await this.prisma.session.update({
      where: { id: session.id },
      data: {
        refreshToken: hashedRefreshToken,
        expiresAt,
      },
    });

    return {
      accessToken,
      refreshToken,
    };
  }
}
