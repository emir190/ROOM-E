import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  AuthUser? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
    );
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  @override
  AuthUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<Result<AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user == null) {
        return const Error(AuthFailure('Kullanıcı bulunamadı / User not found'));
      }
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'lastLoginAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}
      return Success(user);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Kimlik doğrulama hatası', code: e.code));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user == null) {
        return const Error(AuthFailure('Kayıt oluşturulamadı / User creation failed'));
      }
      // Send email verification on signup
      await credential.user?.sendEmailVerification();
      
      // Initialize real Firestore document under users/{uid}
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'onboardingCompleted': false,
        }, SetOptions(merge: true));
      } catch (_) {}

      return Success(user);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Kayıt sırasında hata oluştu', code: e.code));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    try {
      // Create GoogleAuthProvider credential
      final googleProvider = GoogleAuthProvider();
      final credential = await _firebaseAuth.signInWithProvider(googleProvider);
      final user = _mapFirebaseUser(credential.user);
      if (user == null) {
        return const Error(AuthFailure('Google girişi başarısız'));
      }
      return Success(user);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Google ile giriş hatası', code: e.code));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthUser>> signInWithDemo() async {
    const demoUser = AuthUser(
      uid: 'demo_user_01',
      email: 'demo@roomie.app',
      displayName: 'Deniz Yılmaz',
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      isEmailVerified: true,
    );
    return const Success(demoUser);
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Error(AuthFailure('Aktif oturum bulunamadı'));
      }
      await user.sendEmailVerification();
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'E-posta gönderilemedi', code: e.code));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Yenileme başarısız', code: e.code));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Şifre sıfırlama hatası', code: e.code));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(null);
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }
}
