import 'dart:async';
import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationCategory {
  highMatch,
  chatMessage,
  houseRules,
}

class AppPushNotification {
  final String id;
  final String titleTr;
  final String titleEn;
  final String bodyTr;
  final String bodyEn;
  final NotificationCategory category;
  final DateTime createdAt;
  final String? candidateId;
  final bool isRead;

  const AppPushNotification({
    required this.id,
    required this.titleTr,
    required this.titleEn,
    required this.bodyTr,
    required this.bodyEn,
    required this.category,
    required this.createdAt,
    this.candidateId,
    this.isRead = false,
  });

  String getTitle(bool isTr) => isTr ? titleTr : titleEn;
  String getBody(bool isTr) => isTr ? bodyTr : bodyEn;

  AppPushNotification copyWith({bool? isRead}) {
    return AppPushNotification(
      id: id,
      titleTr: titleTr,
      titleEn: titleEn,
      bodyTr: bodyTr,
      bodyEn: bodyEn,
      category: category,
      createdAt: createdAt,
      candidateId: candidateId,
      isRead: isRead ?? this.isRead,
    );
  }
}

class PushNotificationState {
  final List<AppPushNotification> notifications;
  final AppPushNotification? activeBanner;
  final bool fcmInitialized;

  const PushNotificationState({
    this.notifications = const [],
    this.activeBanner,
    this.fcmInitialized = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  PushNotificationState copyWith({
    List<AppPushNotification>? notifications,
    AppPushNotification? activeBanner,
    bool clearBanner = false,
    bool? fcmInitialized,
  }) {
    return PushNotificationState(
      notifications: notifications ?? this.notifications,
      activeBanner: clearBanner ? null : (activeBanner ?? this.activeBanner),
      fcmInitialized: fcmInitialized ?? this.fcmInitialized,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('FCM Background message received: ${message.messageId}');
}

final pushNotificationProvider =
    StateNotifierProvider<PushNotificationController, PushNotificationState>((ref) {
  return PushNotificationController();
});

class PushNotificationController extends StateNotifier<PushNotificationState> {
  Timer? _bannerTimer;
  bool _initialMatchTriggered = false;

  PushNotificationController()
      : super(
          PushNotificationState(
            notifications: [
              AppPushNotification(
                id: 'notif_seed_1',
                titleTr: '🎯 Yüksek Uyumlu Yeni Eşleşme Adayı!',
                titleEn: '🎯 High-Harmony New Match Candidate!',
                bodyTr:
                    'Elif Kaya (Kadıköy • Pazar temizlik ve 23:00 sessizlik uyumu) kriterlerinle eşleşti!',
                bodyEn:
                    'Elif Kaya (Kadikoy • Sunday cleaning & 23:00 quiet hours alignment) matched with your criteria!',
                category: NotificationCategory.highMatch,
                createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
                candidateId: 'cand_1',
              ),
            ],
          ),
        );

  /// Initializes Firebase Cloud Messaging (FCM) listeners and permissions
  Future<void> initializeFCM() async {
    if (state.fcmInitialized) return;
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final title = message.notification?.title ?? 'Roomie Bildirimi';
        final body = message.notification?.body ?? 'Yeni bir güncelleme var.';
        triggerPushNotification(
          titleTr: title,
          titleEn: title,
          bodyTr: body,
          bodyEn: body,
          category: NotificationCategory.highMatch,
          candidateId: message.data['candidateId'] as String?,
        );
      });

      state = state.copyWith(fcmInitialized: true);
    } catch (e) {
      // Runs smoothly in offline/demo or widget test environments without native FCM
      developer.log('FCM running in local/simulated push mode: $e');
      state = state.copyWith(fcmInitialized: true);
    }
  }

  /// Triggers a live Push Notification with haptic feedback and heads-up banner
  void triggerPushNotification({
    required String titleTr,
    required String titleEn,
    required String bodyTr,
    required String bodyEn,
    required NotificationCategory category,
    String? candidateId,
  }) {
    HapticFeedback.mediumImpact();

    final notification = AppPushNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      titleTr: titleTr,
      titleEn: titleEn,
      bodyTr: bodyTr,
      bodyEn: bodyEn,
      category: category,
      createdAt: DateTime.now(),
      candidateId: candidateId,
    );

    final updatedList = [notification, ...state.notifications];
    state = state.copyWith(
      notifications: updatedList,
      activeBanner: notification,
    );

    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        dismissBanner();
      }
    });
  }

  /// Automatically triggers a meaningful high-compatibility match push notification once on discovery
  void triggerDiscoveryWelcomeMatchIfNeeded() {
    if (_initialMatchTriggered) return;
    _initialMatchTriggered = true;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      triggerPushNotification(
        titleTr: '🔥 Yeni Aday: Elif Kaya (Yüksek Uyum)',
        titleEn: '🔥 New Candidate: Elif Kaya (High Harmony)',
        bodyTr:
            'Pazar temizlik rutini ve 23:00 sonrası sessizlik beklentiniz örtüşüyor. Ev kurallarını inceleyin!',
        bodyEn:
            'Sunday cleaning routine and post-23:00 quiet hours align with your profile. Review house rules!',
        category: NotificationCategory.highMatch,
        candidateId: 'cand_1',
      );
    });
  }

  /// Triggers a push notification when AI House Rules are mutually accepted
  void notifyHouseRulesAccepted(String candidateName, int ruleCount, String candidateId) {
    triggerPushNotification(
      titleTr: '📋 Ev Kuralları Sözleşmesi Onaylandı!',
      titleEn: '📋 House Rules Agreement Approved!',
      bodyTr:
          '$candidateName ile $ruleCount ortak ev kuralında (sessizlik, bulaşık, misafir) uzlaştınız. Sohbet açıldı!',
      bodyEn:
          'You and $candidateName agreed on $ruleCount shared house rules (quiet hours, dishes, guests). Chat unlocked!',
      category: NotificationCategory.houseRules,
      candidateId: candidateId,
    );
  }

  /// Triggers a push notification when a new message arrives in chat
  void notifyIncomingChatMessage({
    required String candidateName,
    required String messagePreviewTr,
    required String messagePreviewEn,
    required String candidateId,
  }) {
    triggerPushNotification(
      titleTr: '💬 $candidateName yeni bir mesaj gönderdi',
      titleEn: '💬 New message from $candidateName',
      bodyTr: messagePreviewTr,
      bodyEn: messagePreviewEn,
      category: NotificationCategory.chatMessage,
      candidateId: candidateId,
    );
  }

  void dismissBanner() {
    _bannerTimer?.cancel();
    state = state.copyWith(clearBanner: true);
  }

  void markAllAsRead() {
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(notifications: updated, clearBanner: true);
  }

  void markAsRead(String id) {
    final updated = state.notifications
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    state = state.copyWith(notifications: updated);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }
}

/// Global Heads-Up Push Notification Banner Widget
class PushNotificationBannerOverlay extends ConsumerWidget {
  final Widget child;

  const PushNotificationBannerOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifState = ref.watch(pushNotificationProvider);
    final banner = notifState.activeBanner;
    final locale = ref.watch(
      Provider<Locale>((ref) => Localizations.maybeLocaleOf(context) ?? const Locale('tr')),
    );
    final isTr = locale.languageCode == 'tr';

    return Stack(
      children: [
        child,
        if (banner != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF0F172A),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  ref.read(pushNotificationProvider.notifier).markAsRead(banner.id);
                  ref.read(pushNotificationProvider.notifier).dismissBanner();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          switch (banner.category) {
                            NotificationCategory.highMatch => Icons.auto_awesome,
                            NotificationCategory.houseRules => Icons.handshake_rounded,
                            NotificationCategory.chatMessage => Icons.chat_bubble_rounded,
                          },
                          color: const Color(0xFF2DD4BF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              banner.getTitle(isTr),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              banner.getBody(isTr),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                        onPressed: () {
                          ref.read(pushNotificationProvider.notifier).dismissBanner();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
