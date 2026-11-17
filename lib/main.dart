import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    developer.log(
      'Firebase initialization warning (running in mock/test mode until flutterfire configure): $e',
      stackTrace: st,
    );
  }

  runApp(
    const ProviderScope(
      child: RoomieApp(),
    ),
  );
}
