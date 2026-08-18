import { Test, TestingModule } from '@nestjs/testing';
import { ReservationTransactionService } from './reservation-transaction.service';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { OutboxService } from '../../common/outbox/outbox.service';
import { Prisma, StockMovementType, ReservationStatus } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';

describe('ReservationTransactionService (Concurrency)', () => {
  let service: ReservationTransactionService;
  let prisma: PrismaService;
  let audit: AuditService;

  beforeEach(async () => {
    // Mock the dependencies
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReservationTransactionService,
        {
          provide: PrismaService,
          useValue: {
            $transaction: jest.fn().mockImplementation(async (cb) => {
              // Inject a mocked transaction client
              const mockTxClient = {
                $queryRawUnsafe: jest.fn(),
                inventory: {
                  update: jest.fn(),
                  findUnique: jest.fn(),
                },
                inventoryStockMovement: {
                  create: jest.fn(),
                },
                reservation: {
                  create: jest.fn(),
                  update: jest.fn(),
                  findMany: jest.fn(),
                  count: jest.fn(),
                },
                reservationItem: {
                  findMany: jest.fn(),
                },
              };
              return cb(mockTxClient);
            }),
          },
        },
        {
          provide: AuditService,
          useValue: {
            log: jest.fn().mockResolvedValue(true),
          },
        },
        {
          provide: OutboxService,
          useValue: {
            createEvent: jest.fn().mockResolvedValue(true),
          },
        },
      ],
    }).compile();

    service = module.get<ReservationTransactionService>(
      ReservationTransactionService,
    );
    prisma = module.get<PrismaService>(PrismaService);
    audit = module.get<AuditService>(AuditService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createReservation', () => {
    it('should lock inventory rows using FOR UPDATE', async () => {
      const mockTxClient = {
        $queryRawUnsafe: jest
          .fn()
          .mockResolvedValue([
            { id: 'inv-1', stockQuantity: 10, reservedQuantity: 0 },
          ]),
        inventory: { update: jest.fn().mockResolvedValue({}) },
        inventoryStockMovement: { create: jest.fn().mockResolvedValue({}) },
        reservation: { create: jest.fn().mockResolvedValue({ id: 'res-1' }) },
      };

      jest
        .spyOn(prisma, '$transaction')
        .mockImplementation(async (cb: any) => cb(mockTxClient));

      await service.createReservation({
        customerId: 'cust-1',
        storeId: 'store-1',
        reservationCode: 'FS-123',
        expiresAt: new Date(),
        items: [
          {
            inventoryId: 'inv-1',
            productId: 'prod-1',
            offerId: null,
            quantity: 2,
            originalUnitPrice: new Prisma.Decimal(100),
            discountedUnitPrice: new Prisma.Decimal(100),
            discountAmount: new Prisma.Decimal(0),
            subtotal: new Prisma.Decimal(200),
          },
        ],
        subtotal: new Prisma.Decimal(200),
        totalDiscount: new Prisma.Decimal(0),
        totalAmount: new Prisma.Decimal(200),
      });

      expect(mockTxClient.$queryRawUnsafe).toHaveBeenCalledWith(
        expect.stringContaining('FOR UPDATE'),
        'inv-1',
      );
    });

    it('should fail if requested quantity exceeds available stock', async () => {
      const mockTxClient = {
        $queryRawUnsafe: jest.fn().mockResolvedValue([
          { id: 'inv-1', stockQuantity: 10, reservedQuantity: 9 }, // Only 1 available
        ]),
      };

      jest
        .spyOn(prisma, '$transaction')
        .mockImplementation(async (cb: any) => cb(mockTxClient));

      await expect(
        service.createReservation({
          customerId: 'cust-1',
          storeId: 'store-1',
          reservationCode: 'FS-123',
          expiresAt: new Date(),
          items: [
            {
              inventoryId: 'inv-1',
              productId: 'prod-1',
              offerId: null,
              quantity: 2, // Requesting 2
              originalUnitPrice: new Prisma.Decimal(100),
              discountedUnitPrice: new Prisma.Decimal(100),
              discountAmount: new Prisma.Decimal(0),
              subtotal: new Prisma.Decimal(200),
            },
          ],
          subtotal: new Prisma.Decimal(200),
          totalDiscount: new Prisma.Decimal(0),
          totalAmount: new Prisma.Decimal(200),
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('releaseReservation', () => {
    it('should decrement reserved quantity but not stock quantity', async () => {
      const mockTxClient = {
        $queryRawUnsafe: jest
          .fn()
          .mockResolvedValueOnce([
            {
              id: 'res-1',
              status: ReservationStatus.PENDING,
              reservationCode: 'CODE',
            },
          ]) // Reservation lock
          .mockResolvedValueOnce([{ id: 'inv-1' }]), // Inventory lock
        reservationItem: {
          findMany: jest
            .fn()
            .mockResolvedValue([{ inventoryId: 'inv-1', quantity: 2 }]),
        },
        inventory: {
          update: jest.fn().mockResolvedValue({}),
          findUnique: jest.fn().mockResolvedValue({ stockQuantity: 10 }),
        },
        inventoryStockMovement: { create: jest.fn().mockResolvedValue({}) },
        reservation: {
          update: jest.fn().mockResolvedValue({
            id: 'res-1',
            status: ReservationStatus.CANCELLED,
          }),
        },
      };

      jest
        .spyOn(prisma, '$transaction')
        .mockImplementation(async (cb: any) => cb(mockTxClient));

      await service.releaseReservation(
        'res-1',
        ReservationStatus.CANCELLED,
        'user-1',
        'Test cancel',
      );

      expect(mockTxClient.inventory.update).toHaveBeenCalledWith({
        where: { id: 'inv-1' },
        data: { reservedQuantity: { decrement: 2 } },
      });

      expect(mockTxClient.inventoryStockMovement.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            type: StockMovementType.RESERVATION_RELEASED,
            quantity: 2,
            previousQuantity: 10,
            newQuantity: 10, // Unchanged
          }),
        }),
      );
    });
  });
});
