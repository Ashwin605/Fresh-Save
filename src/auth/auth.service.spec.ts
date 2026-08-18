import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import {
  ConflictException,
  UnauthorizedException,
  ForbiddenException,
} from '@nestjs/common';
import * as argon2 from 'argon2';

// Mock dependencies
const mockPrismaService = {
  user: {
    findFirst: jest.fn(),
    create: jest.fn(),
    findUnique: jest.fn(),
    update: jest.fn(),
  },
  session: {
    create: jest.fn(),
    update: jest.fn(),
    findUnique: jest.fn(),
    updateMany: jest.fn(),
  },
};

const mockJwtService = {
  signAsync: jest.fn(),
  verifyAsync: jest.fn(),
  decode: jest.fn(),
};

const mockConfigService = {
  get: jest.fn().mockReturnValue('secret'),
};

jest.mock('argon2', () => ({
  hash: jest.fn().mockResolvedValue('hashedPassword'),
  verify: jest.fn().mockResolvedValue(true),
}));

describe('AuthService', () => {
  let service: AuthService;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: JwtService, useValue: mockJwtService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  describe('register', () => {
    it('should register a new user successfully', async () => {
      mockPrismaService.user.findFirst.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue({
        id: '1',
        email: 'test@test.com',
        role: 'CUSTOMER',
        password: 'hashedPassword',
      });

      const result = await service.register({
        name: 'Test',
        email: 'test@test.com',
        password: 'password123',
      });

      expect(result).not.toHaveProperty('password');
      expect(result.email).toBe('test@test.com');
      expect(argon2.hash).toHaveBeenCalledWith('password123');
    });

    it('should throw ConflictException if email exists', async () => {
      mockPrismaService.user.findFirst.mockResolvedValue({
        email: 'test@test.com',
      });

      await expect(
        service.register({
          name: 'Test',
          email: 'test@test.com',
          password: 'password123',
        }),
      ).rejects.toThrow(ConflictException);
    });
  });

  describe('login', () => {
    it('should login successfully and return tokens', async () => {
      const user = {
        id: '1',
        email: 'test@test.com',
        password: 'hashedPassword',
        status: 'ACTIVE',
        role: 'CUSTOMER',
      };
      mockPrismaService.user.findUnique.mockResolvedValue(user);
      (argon2.verify as jest.Mock).mockResolvedValue(true);

      mockPrismaService.session.create.mockResolvedValue({ id: 'session1' });
      mockJwtService.signAsync.mockResolvedValue('token');
      mockJwtService.decode.mockReturnValue({ exp: 1234567890 });

      const result = await service.login({
        email: 'test@test.com',
        password: 'password123',
      });

      expect(result).toHaveProperty('accessToken');
      expect(result).toHaveProperty('refreshToken');
      expect(result.user).not.toHaveProperty('password');
    });

    it('should throw UnauthorizedException for invalid password', async () => {
      const user = {
        id: '1',
        email: 'test@test.com',
        password: 'hashedPassword',
        status: 'ACTIVE',
      };
      mockPrismaService.user.findUnique.mockResolvedValue(user);
      (argon2.verify as jest.Mock).mockResolvedValue(false); // Invalid password

      await expect(
        service.login({
          email: 'test@test.com',
          password: 'wrongpassword',
        }),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('should throw ForbiddenException if account is not ACTIVE', async () => {
      const user = {
        id: '1',
        email: 'test@test.com',
        password: 'hashedPassword',
        status: 'SUSPENDED',
      };
      mockPrismaService.user.findUnique.mockResolvedValue(user);

      await expect(
        service.login({
          email: 'test@test.com',
          password: 'password123',
        }),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('refresh', () => {
    it('should throw UnauthorizedException if session is revoked', async () => {
      mockJwtService.verifyAsync.mockResolvedValue({
        sub: 'user1',
        sessionId: 'session1',
      });
      mockPrismaService.session.findUnique.mockResolvedValue({
        id: 'session1',
        isRevoked: true,
      });

      await expect(service.refresh({ refreshToken: 'token' })).rejects.toThrow(
        UnauthorizedException,
      );

      // Verify it revokes all sessions as a security measure
      expect(mockPrismaService.session.updateMany).toHaveBeenCalledWith({
        where: { userId: 'user1' },
        data: { isRevoked: true },
      });
    });

    it('should refresh tokens successfully', async () => {
      mockJwtService.verifyAsync.mockResolvedValue({
        sub: 'user1',
        sessionId: 'session1',
      });
      mockPrismaService.session.findUnique.mockResolvedValue({
        id: 'session1',
        isRevoked: false,
        refreshToken: 'hashedRefreshToken',
      });
      (argon2.verify as jest.Mock).mockResolvedValue(true);
      mockPrismaService.user.findUnique.mockResolvedValue({
        id: 'user1',
        status: 'ACTIVE',
        role: 'CUSTOMER',
      });
      mockPrismaService.session.create.mockResolvedValue({ id: 'session2' });
      mockJwtService.signAsync.mockResolvedValue('token');
      mockJwtService.decode.mockReturnValue({ exp: 1234567890 });

      const result = await service.refresh({ refreshToken: 'token' });

      // Ensure old session is revoked
      expect(mockPrismaService.session.update).toHaveBeenCalledWith({
        where: { id: 'session1' },
        data: { isRevoked: true },
      });

      expect(result).toHaveProperty('accessToken');
      expect(result).toHaveProperty('refreshToken');
    });
  });

  describe('logout', () => {
    it('should revoke the session', async () => {
      await service.logout('session1');
      expect(mockPrismaService.session.update).toHaveBeenCalledWith({
        where: { id: 'session1' },
        data: { isRevoked: true },
      });
    });
  });
});
