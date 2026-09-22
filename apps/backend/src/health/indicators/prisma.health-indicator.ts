import { Injectable } from '@nestjs/common';
import {
  HealthIndicator,
  HealthIndicatorResult,
  HealthCheckError,
} from '@nestjs/terminus';
import { PrismaService } from '../../database/prisma/prisma.service';

@Injectable()
export class PrismaHealthIndicator extends HealthIndicator {
  constructor(private readonly prismaService: PrismaService) {
    super();
  }

  async isHealthy(key: string = 'database'): Promise<HealthIndicatorResult> {
    const isHealthy = await this.prismaService.isHealthy();

    const result = this.getStatus(key, isHealthy, {
      type: 'PostgreSQL',
    });

    if (isHealthy) {
      return result;
    }

    throw new HealthCheckError('Database health check failed', result);
  }
}
