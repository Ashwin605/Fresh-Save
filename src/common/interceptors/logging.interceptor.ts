import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Request, Response } from 'express';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name);

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const request = context.switchToHttp().getRequest<Request>();
    const { method, url } = request;
    const requestIdHeader = request.headers['x-request-id'];
    const requestId: string = Array.isArray(requestIdHeader)
      ? (requestIdHeader[0] ?? 'N/A')
      : (requestIdHeader ?? 'N/A');
    const now = Date.now();

    this.logger.log(`→ ${method} ${url} [${requestId}]`);

    return next.handle().pipe(
      tap({
        next: () => {
          const responseTime = Date.now() - now;
          const response = context.switchToHttp().getResponse<Response>();
          const statusCode: number = response.statusCode;
          this.logger.log(
            `← ${method} ${url} ${statusCode.toString()} ${responseTime.toString()}ms [${requestId}]`,
          );
        },
        error: (error: Error) => {
          const responseTime = Date.now() - now;
          this.logger.error(
            `← ${method} ${url} ERROR ${responseTime.toString()}ms [${requestId}]: ${error.message}`,
          );
        },
      }),
    );
  }
}
