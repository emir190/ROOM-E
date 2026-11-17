import '../../../../core/errors/result.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> authStateChanges();
  AuthUser? get currentUser;

  Future<Result<AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> signInWithGoogle();

  Future<Result<AuthUser>> signInWithDemo();

  Future<Result<void>> sendEmailVerification();

  Future<Result<void>> reloadUser();

  Future<Result<void>> sendPasswordResetEmail(String email);

  Future<Result<void>> signOut();
}
