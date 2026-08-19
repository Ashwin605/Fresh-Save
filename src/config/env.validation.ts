import { plainToInstance } from 'class-transformer';
import {
  IsEnum,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
  validateSync,
} from 'class-validator';

enum Environment {
  Development = 'development',
  Production = 'production',
  Test = 'test',
}

class EnvironmentVariables {
  // ---------- Application ----------
  @IsEnum(Environment)
  NODE_ENV: Environment = Environment.Development;

  @IsNumber()
  @Min(1)
  @Max(65535)
  APP_PORT: number = 3000;

  @IsString()
  APP_NAME: string = 'FreshSave';

  @IsString()
  API_PREFIX: string = 'api/v1';

  @IsString()
  @IsOptional()
  CORS_ORIGINS?: string;

  // ---------- Database ----------
  @IsString()
  DATABASE_HOST: string = 'localhost';

  @IsNumber()
  @Min(1)
  @Max(65535)
  DATABASE_PORT: number = 5432;

  @IsString()
  DATABASE_USER: string = 'freshsave';

  @IsString()
  DATABASE_PASSWORD: string = 'freshsave_secret';

  @IsString()
  DATABASE_NAME: string = 'freshsave_db';

  @IsString()
  DATABASE_URL: string =
    'postgresql://freshsave:freshsave_secret@localhost:5432/freshsave_db?schema=public';

  // ---------- Redis ----------
  @IsString()
  REDIS_HOST: string = 'localhost';

  @IsNumber()
  @Min(1)
  @Max(65535)
  REDIS_PORT: number = 6379;

  @IsString()
  @IsOptional()
  REDIS_PASSWORD?: string;

  @IsNumber()
  @IsOptional()
  REDIS_DB?: number;

  @IsString()
  @IsOptional()
  REDIS_URL?: string;

  // ---------- Logging ----------
  @IsString()
  @IsOptional()
  LOG_LEVEL?: string;

  // ---------- Authentication ----------
  @IsString()
  JWT_ACCESS_SECRET: string = 'super_secret_access_key_change_me_in_prod';

  @IsString()
  JWT_REFRESH_SECRET: string = 'super_secret_refresh_key_change_me_in_prod';

  @IsString()
  JWT_ACCESS_EXPIRATION: string = '15m';

  @IsString()
  JWT_REFRESH_EXPIRATION: string = '7d';
}

export function validate(
  config: Record<string, unknown>,
): EnvironmentVariables {
  const validatedConfig = plainToInstance(EnvironmentVariables, config, {
    enableImplicitConversion: true,
  });

  const errors = validateSync(validatedConfig, {
    skipMissingProperties: false,
  });

  if (errors.length > 0) {
    const formattedErrors = errors
      .map((error) => {
        const constraints = error.constraints
          ? Object.values(error.constraints).join(', ')
          : 'unknown error';
        return `  - ${error.property}: ${constraints}`;
      })
      .join('\n');

    throw new Error(
      `\n❌ Environment validation failed:\n${formattedErrors}\n`,
    );
  }

  return validatedConfig;
}
