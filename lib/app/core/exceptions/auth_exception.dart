class AuthException implements Exception {
  final String message;

  AuthException({required this.message});
}

final class AuthError extends AuthException {
  AuthError({required super.message});
}

final class LoginException extends AuthException {
  LoginException({required super.message});
}

final class RegisterException extends AuthException {
  RegisterException({required super.message});
}

final class LogoutException extends AuthException {
  LogoutException({required super.message});
}
