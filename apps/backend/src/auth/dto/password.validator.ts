import {
  registerDecorator,
  ValidationOptions,
  ValidationArguments,
} from 'class-validator';

/**
 * Custom validator decorator that enforces strong password requirements:
 * - Minimum 8 characters
 * - At least 1 uppercase letter
 * - At least 1 lowercase letter
 * - At least 1 digit
 * - At least 1 special character (!@#$%^&*()_+-=[]{}|;':",./<>?)
 */
export function StrongPassword(validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'strongPassword',
      target: object.constructor,
      propertyName: propertyName,
      options: {
        message:
          'Password must be at least 8 characters with 1 uppercase, 1 lowercase, 1 number, and 1 special character',
        ...validationOptions,
      },
      validator: {
        validate(value: unknown, _args: ValidationArguments): boolean {
          if (typeof value !== 'string') return false;
          if (value.length < 8) return false;
          if (value.length > 128) return false; // Prevent excessively long passwords (Argon2 DoS)
          if (!/[A-Z]/.test(value)) return false;
          if (!/[a-z]/.test(value)) return false;
          if (!/[0-9]/.test(value)) return false;
          if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(value))
            return false;
          return true;
        },
      },
    });
  };
}
