import 'app_error.dart';

class AppErrorMapper {
  static String getMessage(AppError error) {
    return error.when(
      network: (msg) => 'You\'re offline. Check your connection.',
      timeout: (msg) => 'That took longer than expected. Please try again.',
      unauthorized: (msg) => 'Your session has expired. Please sign in again.',
      forbidden: (msg) => 'You don\'t have permission to do this.',
      notFound: (msg) => 'This content is no longer available.',
      conflict: (msg) =>
          'This information was changed elsewhere. Please refresh.',
      validation: (msg, errors) =>
          'Please check your information and try again.',
      rateLimited: (msg) => 'Please wait a moment and try again.',
      server: (msg) => 'Something went wrong on our side.',
      serviceUnavailable: (msg) => 'FreshSave is temporarily unavailable.',
      unknown: (msg) => 'An unexpected error occurred.',
    );
  }

  static String getTitle(AppError error) {
    return error.when(
      network: (_) => 'You\'re Offline',
      timeout: (_) => 'Request Timeout',
      unauthorized: (_) => 'Session Expired',
      forbidden: (_) => 'Access Denied',
      notFound: (_) => 'Not Found',
      conflict: (_) => 'Conflict',
      validation: (msg, errors) => 'Invalid Input',
      rateLimited: (_) => 'Too Many Requests',
      server: (_) => 'Server Error',
      serviceUnavailable: (_) => 'Service Unavailable',
      unknown: (_) => 'Oops!',
    );
  }
}
