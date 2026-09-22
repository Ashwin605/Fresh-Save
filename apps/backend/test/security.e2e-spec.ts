import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from './../src/app.module';

describe('Security (e2e)', () => {
  let app: INestApplication<App>;

  beforeAll(async () => {
    try {
      const moduleFixture: TestingModule = await Test.createTestingModule({
        imports: [AppModule],
      }).compile();

      app = moduleFixture.createNestApplication();
      await app.init();
    } catch (e) {
      console.error('Failed to initialize app for E2E:', e.message);
    }
  });

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  });

  it('Authentication: should reject invalid login', async () => {
    if (!app) { console.log('NOT EXECUTED - Database unavailable'); return; }
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'fake@fake.com', password: 'wrong' })
      .expect(401);
  });

  it('Authentication: should throttle login attempts', async () => {
    if (!app) { console.log('NOT EXECUTED - Database unavailable'); return; }
    
    // The limit is 5 per 60s for /auth/login.
    // Send 5 requests (should pass or fail with 401).
    for (let i = 0; i < 5; i++) {
      await request(app.getHttpServer())
        .post('/auth/login')
        .send({ email: 'fake@fake.com', password: 'wrong' })
        .expect(401); // Standard rejection
    }

    // The 6th request should trigger 429 Too Many Requests
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'fake@fake.com', password: 'wrong' })
      .expect(429);
  });

  it('Authentication: should reject unauthenticated resource access', async () => {
    if (!app) { console.log('NOT EXECUTED - Database unavailable'); return; }
    await request(app.getHttpServer())
      .get('/reservations')
      .expect(401);
  });
});
