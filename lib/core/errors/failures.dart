abstract class Failure {
  final String message;
  final String? code;
  final dynamic cause;

  const Failure(this.message, {this.code, this.cause});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.cause});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.cause});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.cause});
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code, super.cause});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code, super.cause});
}
