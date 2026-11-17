import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roomie/core/errors/failures.dart';
import 'package:roomie/core/errors/result.dart';
import 'package:roomie/features/auth/application/auth_controller.dart';
import 'package:roomie/features/auth/application/auth_state.dart';
import 'package:roomie/features/auth/domain/entities/auth_user.dart';
import 'package:roomie/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthController authController;

  const testUser = AuthUser(
    uid: 'user123',
    email: 'test@example.com',
    displayName: 'Test User',
    isEmailVerified: true,
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.currentUser).thenReturn(null);
    when(() => mockAuthRepository.authStateChanges())
        .thenAnswer((_) => Stream.value(null));

    authController = AuthController(mockAuthRepository);
  });

  tearDown(() {
    authController.dispose();
  });

  group('AuthController Tests', () {
    test('initial state is unauthenticated when currentUser is null', () {
      expect(authController.state.status, AuthStatus.unauthenticated);
      expect(authController.state.user, isNull);
    });

    test('signInWithEmail success updates state to authenticated', () async {
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => const Success(testUser));

      final success = await authController.signInWithEmail(
        'test@example.com',
        'password123',
      );

      expect(success, isTrue);
      expect(authController.state.status, AuthStatus.authenticated);
      expect(authController.state.user, testUser);
      expect(authController.state.failure, isNull);
    });

    test('signInWithEmail failure updates state with failure', () async {
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            email: 'wrong@example.com',
            password: 'password123',
          )).thenAnswer((_) async => const Error(AuthFailure('Invalid credentials')));

      final success = await authController.signInWithEmail(
        'wrong@example.com',
        'password123',
      );

      expect(success, isFalse);
      expect(authController.state.failure, isA<AuthFailure>());
      expect(authController.state.failure!.message, 'Invalid credentials');
    });

    test('signOut updates state to unauthenticated', () async {
      when(() => mockAuthRepository.signOut())
          .thenAnswer((_) async => const Success(null));

      await authController.signOut();

      expect(authController.state.status, AuthStatus.unauthenticated);
      expect(authController.state.user, isNull);
    });
  });
}
