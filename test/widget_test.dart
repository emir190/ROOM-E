import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roomie/core/l10n/app_localizations.dart';
import 'package:roomie/core/theme/app_theme.dart';
import 'package:roomie/features/auth/application/auth_controller.dart';
import 'package:roomie/features/auth/domain/repositories/auth_repository.dart';
import 'package:roomie/features/auth/presentation/login_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.currentUser).thenReturn(null);
    when(() => mockAuthRepository.authStateChanges())
        .thenAnswer((_) => Stream.value(null));
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        home: child,
      ),
    );
  }

  testWidgets('LoginScreen renders email, password fields, and submit button',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const LoginScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Roomie'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Google ile Giriş Yap'), findsOneWidget);
    expect(find.text('Kayıt Ol'), findsOneWidget);
  });

  testWidgets('LoginScreen validates empty email and password',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const LoginScreen()));
    await tester.pumpAndSettle();

    // Tap the submit button
    final loginButton = find.widgetWithText(ElevatedButton, 'Giriş Yap');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Lütfen e-posta girin'), findsOneWidget);
    expect(find.text('Şifre en az 6 karakter olmalıdır'), findsOneWidget);
  });
}
