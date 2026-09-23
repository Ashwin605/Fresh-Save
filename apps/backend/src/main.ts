import { NestFactory } from '@nestjs/core';
import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import compression from 'compression';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import * as fs from 'fs';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { LoggingInterceptor } from './common/interceptors/logging.interceptor';

async function bootstrap(): Promise<void> {
  const logger = new Logger('Bootstrap');
  let httpsOptions = undefined;

  const isHttpsEnabled = process.env.HTTPS_ENABLED === 'true';
  if (isHttpsEnabled) {
    try {
      const keyPath = process.env.TLS_KEY_PATH;
      const certPath = process.env.TLS_CERT_PATH;
      if (keyPath && certPath) {
        httpsOptions = {
          key: fs.readFileSync(keyPath),
          cert: fs.readFileSync(certPath),
        };
        logger.log('🔐 HTTPS is enabled with provided certificates.');
      } else {
        logger.warn('HTTPS_ENABLED is true, but TLS_KEY_PATH or TLS_CERT_PATH is missing. Falling back to HTTP.');
      }
    } catch (err: any) {
      logger.error(`Failed to load TLS certificates: ${err.message}. Falling back to HTTP.`);
    }
  }

  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    bufferLogs: true,
    httpsOptions,
  });

  const configService = app.get(ConfigService);

  // ── Global Prefix ──────────────────────────────────────
  const apiPrefix = configService.get<string>('app.apiPrefix', 'api/v1');
  app.setGlobalPrefix(apiPrefix);

  // ── Security ───────────────────────────────────────────
  app.use(helmet());
  app.use(compression());

  // ── CORS ───────────────────────────────────────────────
  const isProduction = configService.get<string>('NODE_ENV') === 'production';
  const corsOrigins = configService.get<string[]>('app.corsOrigins', [
    'http://localhost:3000',
  ]);
  app.enableCors({
    origin: isProduction ? corsOrigins : true, // Allow all origins in development
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-Id'],
    exposedHeaders: ['X-Request-Id'],
    credentials: true,
    maxAge: 3600,
  });

  // ── Static Assets ──────────────────────────────────────
  app.useStaticAssets(join(__dirname, '..', 'public'), {
    prefix: '/public/',
  });

  // ── Global Pipes ───────────────────────────────────────
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // ── Global Filters ─────────────────────────────────────
  app.useGlobalFilters(new AllExceptionsFilter());

  // ── Global Interceptors ────────────────────────────────
  app.useGlobalInterceptors(
    new LoggingInterceptor(),
    new TransformInterceptor(),
  );

  // ── Swagger / OpenAPI ──────────────────────────────────
  const swaggerConfig = new DocumentBuilder()
    .setTitle('FreshSave API')
    .setDescription(
      'FreshSave connects customers with nearby stores offering ' +
        'discounted products approaching their expiry date.',
    )
    .setVersion('1.0.0')
    .addBearerAuth() // Ready for future auth milestone
    .addTag('Health', 'Service health check endpoints')
    .build();

  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api/docs', app, document, {
    swaggerOptions: {
      persistAuthorization: true,
      docExpansion: 'list',
      filter: true,
      showRequestDuration: true,
    },
  });

  // ── Graceful Shutdown ──────────────────────────────────
  app.enableShutdownHooks();

  // ── Start Server ───────────────────────────────────────
  const port = configService.get<number>('app.port', 3000);
  const appName = configService.get<string>('app.name', 'FreshSave');

  await app.listen(port, '0.0.0.0');

  const protocol = httpsOptions ? 'https' : 'http';
  logger.log(
    `🚀 ${appName} API is running on: ${protocol}://localhost:${port}/${apiPrefix}`,
  );
  logger.log(`📚 Swagger docs available at: ${protocol}://localhost:${port}/api/docs`);
  logger.log(
    `🏥 Health check at: ${protocol}://localhost:${port}/${apiPrefix}/health`,
  );
}

void bootstrap();
