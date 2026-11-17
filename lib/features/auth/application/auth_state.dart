import '../../../../core/errors/failures.dart';
import '../domain/entities/auth_user.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final bool isLoading;
  final Failure? failure;

  const AuthState({
    required this.status,
    this.user,
    this.isLoading = false,
    this.failure,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        isLoading = false,
        failure = null;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    bool? isLoading,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
