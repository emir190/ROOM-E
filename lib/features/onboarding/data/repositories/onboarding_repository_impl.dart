import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/image_compressor.dart';
import '../../domain/entities/onboarding_data.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  static const String _kOnboardingKey = 'onboarding_completed_flag';
  static final Map<String, OnboardingData> _memoryCache = {};

  OnboardingRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<Result<OnboardingData?>> getOnboardingData(String uid) async {
    // If running in demo mode, immediately return in-memory cache without waiting for network timeout
    if (uid.startsWith('demo_user_')) {
      return Success(_memoryCache[uid]);
    }
    try {
      final doc = await _firestore.collection('users').doc(uid).get().timeout(const Duration(seconds: 2));
      if (!doc.exists || doc.data() == null) {
        return Success(_memoryCache[uid]);
      }
      return Success(OnboardingData.fromFirestore(doc.data()!));
    } catch (_) {
      // Memory fallback for demo mode
      return Success(_memoryCache[uid]);
    }
  }

  @override
  Future<Result<void>> saveOnboardingData(String uid, OnboardingData data) async {
    _memoryCache[uid] = data;
    if (uid.startsWith('demo_user_')) {
      return const Success(null);
    }
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          ...data.toFirestoreMap(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      ).timeout(const Duration(seconds: 2));
      return const Success(null);
    } catch (_) {
      // Memory fallback for demo mode
      return const Success(null);
    }
  }

  @override
  Future<Result<String>> uploadProfilePhoto(String uid, File photoFile) async {
    // Immediate local file path support in demo mode
    if (uid.startsWith('demo_user_')) {
      return Success(photoFile.path);
    }
    try {
      final compressed = await ImageCompressor.compressImageFile(photoFile);
      final fileToUpload = compressed ?? photoFile;

      final photoId = const Uuid().v4();
      final ref = _storage.ref().child('users/$uid/profile_photos/$photoId.jpg');

      final uploadTask = await ref
          .putFile(
            fileToUpload,
            SettableMetadata(contentType: 'image/jpeg'),
          )
          .timeout(const Duration(seconds: 3));

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return Success(downloadUrl);
    } catch (_) {
      // Fallback to local file path when offline or when Firebase Storage is not configured
      return Success(photoFile.path);
    }
  }

  @override
  Future<bool> isOnboardingCompletedLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kOnboardingKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setOnboardingCompletedLocally(bool completed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOnboardingKey, completed);
    } catch (_) {}
  }
}
