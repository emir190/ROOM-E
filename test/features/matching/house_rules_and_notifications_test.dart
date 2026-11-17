import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomie/core/l10n/app_localizations.dart';
import 'package:roomie/core/notifications/push_notification_service.dart';
import 'package:roomie/core/theme/app_theme.dart';
import 'package:roomie/features/matching/presentation/discover_feed_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PushNotificationController Tests (Madde 8)', () {
    late PushNotificationController controller;

    setUp(() {
      controller = PushNotificationController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state contains seed high-match notification and unreadCount = 1', () {
      expect(controller.state.notifications.length, 1);
      expect(controller.state.unreadCount, 1);
      expect(
        controller.state.notifications.first.category,
        NotificationCategory.highMatch,
      );
    });

    test('triggerPushNotification adds notification and sets activeBanner', () {
      controller.triggerPushNotification(
        titleTr: 'Yeni Yüksek Uyum',
        titleEn: 'New High Match',
        bodyTr: 'Elif Kaya ile eşleştiniz',
        bodyEn: 'You matched with Elif Kaya',
        category: NotificationCategory.highMatch,
        candidateId: 'cand_1',
      );

      expect(controller.state.notifications.length, 2);
      expect(controller.state.unreadCount, 2);
      expect(controller.state.activeBanner, isNotNull);
      expect(controller.state.activeBanner!.titleTr, 'Yeni Yüksek Uyum');
    });

    test('notifyHouseRulesAccepted and notifyIncomingChatMessage create notifications', () {
      controller.notifyHouseRulesAccepted('Elif Kaya', 4, 'cand_1');
      expect(
        controller.state.notifications.first.category,
        NotificationCategory.houseRules,
      );

      controller.notifyIncomingChatMessage(
        candidateName: 'Elif Kaya',
        messagePreviewTr: 'Merhaba!',
        messagePreviewEn: 'Hello!',
        candidateId: 'cand_1',
      );
      expect(
        controller.state.notifications.first.category,
        NotificationCategory.chatMessage,
      );

      controller.markAllAsRead();
      expect(controller.state.unreadCount, 0);
      expect(controller.state.activeBanner, isNull);
    });
  });

  group('HouseRulesAgreementScreen Widget Tests (Madde 9)', () {
    final testCandidate = demoCandidates.first;

    Widget createHouseRulesTestApp() {
      return ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('tr'),
          home: HouseRulesAgreementScreen(candidate: testCandidate),
        ),
      );
    }

    testWidgets(
      'displays AI suggested rules (quiet hours, dish policy, guest policy) and allows toggling and editing',
      (WidgetTester tester) async {
        await tester.pumpWidget(createHouseRulesTestApp());
        await tester.pumpAndSettle();

        // Verify categories are displayed
        expect(find.text('Sessizlik Saatleri'), findsOneWidget);
        expect(find.text('Bulaşık Politikası'), findsOneWidget);
        expect(find.text('Misafir Kuralları'), findsOneWidget);
        expect(find.text('Temizlik & Ortak Alan'), findsOneWidget);

        // Verify all 4 rules are initially approved (4/4 Onaylı)
        expect(find.textContaining('4/4 Onaylı'), findsOneWidget);

        // Toggle off the first rule checkbox
        final firstCheckbox = find.byType(Checkbox).first;
        await tester.tap(firstCheckbox);
        await tester.pumpAndSettle();
        expect(find.textContaining('3/4 Onaylı'), findsOneWidget);

        // Tap edit icon on the first rule to customize it
        final firstEditButton = find.byIcon(Icons.edit_outlined).first;
        await tester.tap(firstEditButton);
        await tester.pumpAndSettle();

        // Enter edited rule text in the modal
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);
        await tester.enterText(
          textField,
          '00:00 - 08:30 arası ortak alanlarda tam sessizlik',
        );
        await tester.tap(find.text('Kuralı Güncelle & Onayla'));
        await tester.pumpAndSettle();

        // Verify the rule text updated, was re-approved, and shows 'Düzenlendi' badge
        expect(
          find.text('00:00 - 08:30 arası ortak alanlarda tam sessizlik'),
          findsOneWidget,
        );
        expect(find.text('Düzenlendi'), findsOneWidget);
        expect(find.textContaining('4/4 Onaylı'), findsOneWidget);
      },
    );
  });
}
