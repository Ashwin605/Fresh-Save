import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';
import { Prisma } from '@prisma/client';

export interface AuditLogEntry {
  actorId?: string;
  action: string;
  entityType: string;
  entityId: string;
  previousData?: any;
  newData?: any;
  ipAddress?: string;
  userAgent?: string;
}

@Injectable()
export class AuditService {
  constructor(private prisma: PrismaService) {}

  async log(entry: AuditLogEntry, prismaClient?: Prisma.TransactionClient) {
    const client = prismaClient || this.prisma;

    // We stringify the data to match the Json type requirement in Prisma safely if it's an object,
    // though Prisma accepts objects directly for Json fields.
    const previousData =
      entry.previousData !== undefined
        ? (entry.previousData as Prisma.InputJsonValue)
        : undefined;
    const newData =
      entry.newData !== undefined
        ? (entry.newData as Prisma.InputJsonValue)
        : undefined;

    return client.auditLog.create({
      data: {
        actorId: entry.actorId,
        action: entry.action,
        entityType: entry.entityType,
        entityId: entry.entityId,
        previousData,
        newData,
        ipAddress: entry.ipAddress,
        userAgent: entry.userAgent,
      },
    });
  }
}
