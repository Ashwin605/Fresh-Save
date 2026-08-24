import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../database/prisma/prisma.service';
import { JwtPayload } from '../auth.service';
import { UserStatus } from '@prisma/client';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('jwt.accessSecret')!,
    });
  }

  async validate(payload: JwtPayload) {
    const { sub: userId, sessionId } = payload;

    // Run session and user lookups in parallel instead of sequentially
    const [session, user] = await Promise.all([
      this.prisma.session.findUnique({ where: { id: sessionId } }),
      this.prisma.user.findUnique({ where: { id: userId } }),
    ]);

    if (!session || session.isRevoked) {
      throw new UnauthorizedException('Session is invalid or expired');
    }

    if (!user || user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException('User is inactive or not found');
    }

    // Attach to req.user
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      sessionId: session.id,
    };
  }
}
