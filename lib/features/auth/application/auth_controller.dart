import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateChangesProvider = StreamProvider<AuthUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  StreamSubscription<AuthUser?>? _subscription;

  AuthController(this._repository) : super(const AuthState.initial()) {
    _init();
  }

  void _init() {
    final current = _repository.currentUser;
    if (current != null) {
      state = state.copyWith(status: AuthStatus.authenticated, user: current);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }

    _subscription = _repository.authStateChanges().listen((user) {
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
          clearFailure: true,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          isLoading: false,
          clearFailure: true,
        );
      }
    });
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final result = await _repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.fold(
      onSuccess: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
        return true;
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
    );
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final result = await _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.fold(
      onSuccess: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
        return true;
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
    );
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final result = await _repository.signInWithGoogle();
    return result.fold(
      onSuccess: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
        return true;
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
    );
  }

  Future<bool> signInWithDemo() async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final result = await _repository.signInWithDemo();
    return result.fold(
      onSuccess: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
        return true;
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
    );
  }

  Future<void> sendEmailVerification() async {
    final result = await _repository.sendEmailVerification();
    result.fold(
      onSuccess: (_) {},
      onError: (failure) {
        state = state.copyWith(failure: failure);
      },
    );
  }

  Future<bool> checkEmailVerification() async {
    await _repository.reloadUser();
    final updatedUser = _repository.currentUser;
    if (updatedUser != null && updatedUser.isEmailVerified) {
      state = state.copyWith(user: updatedUser);
      return true;
    }
    return false;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final result = await _repository.sendPasswordResetEmail(email);
    return result.fold(
      onSuccess: (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _repository.signOut();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      isLoading: false,
    );
  }

  void clearError() {
    state = state.copyWith(clearFailure: true);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
