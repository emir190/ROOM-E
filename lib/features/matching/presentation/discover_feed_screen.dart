import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/notifications/push_notification_service.dart';
import '../../../core/providers/locale_provider.dart';
import '../../auth/application/auth_controller.dart';
import '../../scenarios/application/scenario_controller.dart';

enum HouseRuleCategory {
  quietHours,
  dishPolicy,
  guestPolicy,
  cleaningChores,
}

class HouseRuleItem {
  final String id;
  final HouseRuleCategory category;
  final String textEn;
  final String textTr;
  final bool isAccepted;
  final bool isEdited;

  const HouseRuleItem({
    required this.id,
    required this.category,
    required this.textEn,
    required this.textTr,
    this.isAccepted = true,
    this.isEdited = false,
  });

  String getText(bool isTr) => isTr ? textTr : textEn;

  String getCategoryLabel(bool isTr) {
    return switch (category) {
      HouseRuleCategory.quietHours => isTr ? 'Sessizlik Saatleri' : 'Quiet Hours',
      HouseRuleCategory.dishPolicy => isTr ? 'Bulaşık Politikası' : 'Dish Policy',
      HouseRuleCategory.guestPolicy => isTr ? 'Misafir Kuralları' : 'Guest Policy',
      HouseRuleCategory.cleaningChores => isTr ? 'Temizlik & Ortak Alan' : 'Cleaning & Shared Space',
    };
  }

  IconData get categoryIcon {
    return switch (category) {
      HouseRuleCategory.quietHours => Icons.bedtime_rounded,
      HouseRuleCategory.dishPolicy => Icons.soup_kitchen_rounded,
      HouseRuleCategory.guestPolicy => Icons.people_alt_rounded,
      HouseRuleCategory.cleaningChores => Icons.cleaning_services_rounded,
    };
  }

  List<String> getPresets(bool isTr) {
    return switch (category) {
      HouseRuleCategory.quietHours => isTr
          ? [
              'Hafta içi 23:00 - 08:00, hafta sonu 00:30 - 09:00 arası ortak alanlarda sessizlik',
              'Her gün 22:30 - 07:30 arası ortak alanlarda sessizlik ve kulaklıkla medya kullanımı',
              '00:00 - 08:30 arası düşük ses seviyesi; sınav/proje dönemlerinde tam sessizlik',
            ]
          : [
              'Quiet in shared spaces 23:00 - 08:00 on weekdays, 00:30 - 09:00 on weekends',
              'Quiet hours 22:30 - 07:30 daily with headphone use for media',
              'Low volume 00:00 - 08:30; strict silence during exam/deadline weeks',
            ],
      HouseRuleCategory.dishPolicy => isTr
          ? [
              'Yemekten sonra en geç 2 saat içinde tezgah ve lavabonun temiz bırakılması',
              'Bulaşıkların yemekten hemen sonra makineye dizilmesi, tezgahta bekletilmemesi',
              'Gün içinde kullanılan tabak ve tencerelerin en geç gece yatmadan önce yıkanması',
            ]
          : [
              'Kitchen sink and counter cleared within 2 hours after cooking',
              'Dishes loaded into dishwasher immediately after meals; zero sink backlog',
              'All cookware and dishes washed before going to bed the same night',
            ],
      HouseRuleCategory.guestPolicy => isTr
          ? [
              'Yatılı misafirler için 24 saat önceden haber verilmesi (haftada maks. 2 gece)',
              'Gündüz misafiri serbest; yatılı misafir için önceden karşılıklı onay alınması',
              'Evde kalabalık parti yapılmaması; misafirlerin 23:30\'a kadar ağırlanması',
            ]
          : [
              '24h advance notice for overnight guests (max 2 nights per week)',
              'Daytime guests welcome; mutual approval required beforehand for overnight stays',
              'No house parties; casual guests wrap up by 23:30 on weeknights',
            ],
      HouseRuleCategory.cleaningChores => isTr
          ? [
              'Ortak banyo, mutfak ve salonun her Pazar dönüşümlü olarak temizlenmesi',
              'Çöp dökümü ve geri dönüşümün haftalık nöbet çizelgesiyle paylaşılması',
              'Ortak giderlerin (deterjan, kağıt havlu, fatura) uygulama üzerinden eşit bölüşülmesi',
            ]
          : [
              'Shared bathroom, kitchen, and living room cleaned every Sunday in rotation',
              'Trash disposal and recycling alternated weekly via chore schedule',
              'Shared supplies and utility bills split equally within 24h',
            ],
    };
  }

  HouseRuleItem copyWith({
    HouseRuleCategory? category,
    String? textEn,
    String? textTr,
    bool? isAccepted,
    bool? isEdited,
  }) {
    return HouseRuleItem(
      id: id,
      category: category ?? this.category,
      textEn: textEn ?? this.textEn,
      textTr: textTr ?? this.textTr,
      isAccepted: isAccepted ?? this.isAccepted,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

class RoommateMatchCandidate {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final String? occupationTr;
  final String city;
  final String district;
  final int budget;
  final String photoUrl;
  final String compatibilityTierEn;
  final String compatibilityTierTr;
  final String housingStatusEn;
  final String housingStatusTr;
  final List<String> verifiedFiltersEn;
  final List<String> verifiedFiltersTr;
  final List<String> blindHarmonyAreasEn;
  final List<String> blindHarmonyAreasTr;
  final List<HouseRuleItem> initialHouseRules;

  const RoommateMatchCandidate({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    this.occupationTr,
    required this.city,
    required this.district,
    required this.budget,
    required this.photoUrl,
    required this.compatibilityTierEn,
    required this.compatibilityTierTr,
    required this.housingStatusEn,
    required this.housingStatusTr,
    required this.verifiedFiltersEn,
    required this.verifiedFiltersTr,
    required this.blindHarmonyAreasEn,
    required this.blindHarmonyAreasTr,
    required this.initialHouseRules,
  });

  String getOccupation(bool isTr) => (isTr && occupationTr != null) ? occupationTr! : occupation;
  String getCompatibilityTier(bool isTr) => isTr ? compatibilityTierTr : compatibilityTierEn;
  String getHousingStatus(bool isTr) => isTr ? housingStatusTr : housingStatusEn;
  List<String> getVerifiedFilters(bool isTr) => isTr ? verifiedFiltersTr : verifiedFiltersEn;
  List<String> getBlindHarmonyAreas(bool isTr) => isTr ? blindHarmonyAreasTr : blindHarmonyAreasEn;
}

final demoCandidates = [
  const RoommateMatchCandidate(
    id: 'cand_1',
    name: 'Elif Kaya',
    age: 23,
    occupation: 'Interior Architecture Student',
    occupationTr: 'İç Mimarlık Öğrencisi',
    city: 'Istanbul',
    district: 'Kadikoy (Moda)',
    budget: 14000,
    photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=600&q=80',
    compatibilityTierEn: 'High Harmony • Low Friction',
    compatibilityTierTr: 'Yüksek Uyum • Düşük Sürtüşme',
    housingStatusEn: 'Looking to Team Up',
    housingStatusTr: 'Birlikte Eve Çıkmak İstiyor',
    verifiedFiltersEn: ['Non-Smoking Home', 'Pet-Friendly', '12-Month Lease'],
    verifiedFiltersTr: ['Sigara İçilmeyen Ev', 'Evcil Hayvan Uygun', '12 Ay Kira Planı'],
    blindHarmonyAreasEn: [
      'Common Area Routine & Hygiene Standards (Verified by Blind Engine)',
      'Evening Quiet Hours & Rest Schedule (Verified by Blind Engine)',
      'Transparent Shared Expense & Bill Settlement (Verified by Blind Engine)',
    ],
    blindHarmonyAreasTr: [
      'Ortak Alan Rutini ve Hijyen Standartları (Kapalı Kutu Motorunca Doğrulandı)',
      'Akşam Sessizlik Saatleri ve Dinlenme Düzeni (Kapalı Kutu Motorunca Doğrulandı)',
      'Şeffaf Gider ve Fatura Paylaşımı Yaklaşımı (Kapalı Kutu Motorunca Doğrulandı)',
    ],
    initialHouseRules: [
      HouseRuleItem(
        id: 'rule_elif_1',
        category: HouseRuleCategory.quietHours,
        textEn: 'Silence in shared spaces between 23:00 - 08:00',
        textTr: '23:00 - 08:00 arası ortak alanlarda sessizlik ve düşük ses seviyesi',
      ),
      HouseRuleItem(
        id: 'rule_elif_2',
        category: HouseRuleCategory.dishPolicy,
        textEn: 'Kitchen sink and counter cleared within 2 hours after cooking',
        textTr: 'Yemekten sonra en geç 2 saat içinde mutfak tezgahı ve lavabo temizliği',
      ),
      HouseRuleItem(
        id: 'rule_elif_3',
        category: HouseRuleCategory.guestPolicy,
        textEn: 'Overnight visitors max 2 nights/week with 24h advance notice',
        textTr: '24 saat önceden haber vermek şartıyla haftada maks. 2 gece yatılı misafir',
      ),
      HouseRuleItem(
        id: 'rule_elif_4',
        category: HouseRuleCategory.cleaningChores,
        textEn: 'Shared bathroom & living room deep-cleaned every Sunday',
        textTr: 'Ortak banyo ve salonun her Pazar dönüşümlü olarak temizlenmesi',
      ),
    ],
  ),
  const RoommateMatchCandidate(
    id: 'cand_2',
    name: 'Can Demir',
    age: 24,
    occupation: 'Software Engineer (WFH)',
    occupationTr: 'Yazılım Mühendisi (Home Office)',
    city: 'Istanbul',
    district: 'Besiktas',
    budget: 16500,
    photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=600&q=80',
    compatibilityTierEn: 'High Harmony • Low Friction',
    compatibilityTierTr: 'Yüksek Uyum • Düşük Sürtüşme',
    housingStatusEn: 'Has Apartment, Needs Roommate',
    housingStatusTr: 'Evi Var, Ev Arkadaşı Arıyor',
    verifiedFiltersEn: ['Non-Smoking Home', 'Pet-Free Home', '12-Month Lease'],
    verifiedFiltersTr: ['Sigara İçilmeyen Ev', 'Evcil Hayvansız Ev', '12 Ay Kira Planı'],
    blindHarmonyAreasEn: [
      'Financial Punctuality & Bill Sharing (Verified by Blind Engine)',
      'Direct & Respectful Communication Style (Verified by Blind Engine)',
      'Personal Space & Property Boundaries (Verified by Blind Engine)',
    ],
    blindHarmonyAreasTr: [
      'Kira ve Fatura Ödeme Disiplini (Kapalı Kutu Motorunca Doğrulandı)',
      'Açık ve Saygılı İletişim Beklentisi (Kapalı Kutu Motorunca Doğrulandı)',
      'Kişisel Alan ve Eşya Sınırları Uyumu (Kapalı Kutu Motorunca Doğrulandı)',
    ],
    initialHouseRules: [
      HouseRuleItem(
        id: 'rule_can_1',
        category: HouseRuleCategory.quietHours,
        textEn: 'Keep living room quiet during WFH meetings (09:00 - 18:00) & after 23:30',
        textTr: 'Evden çalışma saatlerinde (09:00 - 18:00) ve 23:30 sonrasında ortak alanda sessizlik',
      ),
      HouseRuleItem(
        id: 'rule_can_2',
        category: HouseRuleCategory.dishPolicy,
        textEn: 'Dishes loaded into dishwasher immediately after meals',
        textTr: 'Bulaşıkların yemekten hemen sonra makineye dizilmesi, tezgahta bekletilmemesi',
      ),
      HouseRuleItem(
        id: 'rule_can_3',
        category: HouseRuleCategory.guestPolicy,
        textEn: 'Weekend guests welcome with advance text notice; no weekday overnight guests',
        textTr: 'Hafta sonu misafirleri için önceden mesajla bilgi; hafta içi yatılı misafir olmaması',
      ),
      HouseRuleItem(
        id: 'rule_can_4',
        category: HouseRuleCategory.cleaningChores,
        textEn: 'Utilities and shared expenses split equally within 24 hours of bill arrival',
        textTr: 'Faturalar ve ortak ev giderlerinin 24 saat içinde uygulama üzerinden bölüşülmesi',
      ),
    ],
  ),
  const RoommateMatchCandidate(
    id: 'cand_3',
    name: 'Zeynep Arslan',
    age: 22,
    occupation: 'Medical Student (Year 4)',
    occupationTr: 'Tıp Öğrencisi (4. Sınıf)',
    city: 'Istanbul',
    district: 'Uskudar',
    budget: 12000,
    photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
    compatibilityTierEn: 'Compatible • Low Friction',
    compatibilityTierTr: 'Uyumlu • Düşük Sürtüşme',
    housingStatusEn: 'Looking for a Room',
    housingStatusTr: 'Oda Arıyor',
    verifiedFiltersEn: ['Non-Smoking Home', 'Quiet Study Environment', '6-12 Months'],
    verifiedFiltersTr: ['Sigara İçilmeyen Ev', 'Sessiz Çalışma Ortamı', '6-12 Ay Kira Planı'],
    blindHarmonyAreasEn: [
      'Quiet Study & Rest Sanctuary Priority (Verified by Blind Engine)',
      'Guest & Gathering Boundaries (Verified by Blind Engine)',
      'Structured Household Chore Rotation (Verified by Blind Engine)',
    ],
    blindHarmonyAreasTr: [
      'Evde Sessiz Çalışma ve Dinlenme Önceliği (Kapalı Kutu Motorunca Doğrulandı)',
      'Misafir ve Kalabalık Etkinlik Sınırları (Kapalı Kutu Motorunca Doğrulandı)',
      'Planlı Ev İçi Görev Dağılımı Uyumu (Kapalı Kutu Motorunca Doğrulandı)',
    ],
    initialHouseRules: [
      HouseRuleItem(
        id: 'rule_zeynep_1',
        category: HouseRuleCategory.quietHours,
        textEn: 'Quiet hours from 22:30 to 08:00 AM due to early hospital shifts',
        textTr: 'Sabah erken hastane nöbetleri nedeniyle 22:30 - 08:00 arası sessizlik saatleri',
      ),
      HouseRuleItem(
        id: 'rule_zeynep_2',
        category: HouseRuleCategory.dishPolicy,
        textEn: 'All cooking pots and dishes washed before bedtime the same day',
        textTr: 'Kullanılan tüm mutfak eşyalarının aynı gün yatmadan önce yıkanması',
      ),
      HouseRuleItem(
        id: 'rule_zeynep_3',
        category: HouseRuleCategory.guestPolicy,
        textEn: 'No crowded parties; study friends welcome with prior heads-up',
        textTr: 'Ev içi kalabalık parti yapılmaması; çalışma arkadaşları için önceden haber verilmesi',
      ),
      HouseRuleItem(
        id: 'rule_zeynep_4',
        category: HouseRuleCategory.cleaningChores,
        textEn: 'Alternating weekly trash, recycling, and bathroom cleaning schedule',
        textTr: 'Çöp dökümü, geri dönüşüm ve banyo temizliğinin haftalık dönüşümlü yapılması',
      ),
    ],
  ),
];

class DiscoverFeedScreen extends ConsumerStatefulWidget {
  const DiscoverFeedScreen({super.key});

  @override
  ConsumerState<DiscoverFeedScreen> createState() => _DiscoverFeedScreenState();
}

class _DiscoverFeedScreenState extends ConsumerState<DiscoverFeedScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Trigger meaningful push notification when entering Discovery
    Future.microtask(() {
      ref.read(pushNotificationProvider.notifier).triggerDiscoveryWelcomeMatchIfNeeded();
    });
  }

  void _onPass() {
    if (_currentIndex < demoCandidates.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _currentIndex = 0);
    }
  }

  void _onInterested(RoommateMatchCandidate candidate) {
    final isTr = ref.read(localeProvider).languageCode == 'tr';
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primaryTealLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.primaryTeal,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isTr ? 'Karşılıklı Eşleşme! 🎉' : 'Mutual Match! 🎉',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isTr
                    ? '${candidate.name} ile eşleştiniz! Sohbet (chat) açılmadan önce; sessizlik saatleri, bulaşık politikası ve misafir kuralları gibi AI tarafından önerilen Ev Kurallarını birlikte onaylayın veya düzenleyin.'
                    : 'You matched with ${candidate.name}! Before chat unlocks, review, approve, or edit AI-suggested House Rules (quiet hours, dish policy, guest rules).',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => HouseRulesAgreementScreen(candidate: candidate),
                    ),
                  );
                },
                child: Text(
                  isTr ? 'Ev Kurallarını Onayla / Düzenle 📋' : 'Approve / Edit House Rules 📋',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _onPass();
                },
                child: Text(isTr ? 'Keşfetmeye Devam Et' : 'Keep Exploring'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationsModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (modalCtx, modalRef, _) {
            final notifState = modalRef.watch(pushNotificationProvider);
            final isTr = modalRef.watch(localeProvider).languageCode == 'tr';
            final theme = Theme.of(modalCtx);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.65,
              maxChildSize: 0.9,
              minChildSize: 0.45,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.notifications_active_rounded, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                isTr ? 'Anlık Bildirimler' : 'Push Notifications',
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              modalRef.read(pushNotificationProvider.notifier).markAllAsRead();
                            },
                            child: Text(isTr ? 'Tümünü Okundu İşaretle' : 'Mark All Read'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Live Push Notification Trigger Button for Demo
                      FilledButton.tonalIcon(
                        onPressed: () {
                          final nextCandidate = demoCandidates[_currentIndex];
                          modalRef.read(pushNotificationProvider.notifier).triggerPushNotification(
                                titleTr: '🔔 Yeni Yüksek Uyumlu Aday: ${nextCandidate.name}!',
                                titleEn: '🔔 New High-Harmony Match: ${nextCandidate.name}!',
                                bodyTr:
                                    '${nextCandidate.district} bölgesinde bütçe ve yaşam tarzı kriterlerinle uyumlu yeni aday bulundu. Ev kurallarını incelemek için dokun!',
                                bodyEn:
                                    'New candidate in ${nextCandidate.district} matches your budget and lifestyle criteria. Tap to review house rules!',
                                category: NotificationCategory.highMatch,
                                candidateId: nextCandidate.id,
                              );
                        },
                        icon: const Icon(Icons.send_to_mobile_rounded, size: 18),
                        label: Text(
                          isTr
                              ? 'Yeni Eşleşme Anlık Bildirimi Gönder (Canlı Test)'
                              : 'Trigger Live Match Push Notification (Test)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                        ),
                      ),
                      const Divider(height: 20),
                      Expanded(
                        child: notifState.notifications.isEmpty
                            ? Center(
                                child: Text(
                                  isTr ? 'Henüz bildirim yok.' : 'No notifications yet.',
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: notifState.notifications.length,
                                itemBuilder: (_, idx) {
                                  final item = notifState.notifications[idx];
                                  return Card(
                                    color: item.isRead
                                        ? theme.colorScheme.surface
                                        : theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                                        child: Icon(
                                          switch (item.category) {
                                            NotificationCategory.highMatch => Icons.auto_awesome,
                                            NotificationCategory.houseRules => Icons.handshake_rounded,
                                            NotificationCategory.chatMessage => Icons.chat_bubble_rounded,
                                          },
                                          color: AppColors.primaryTeal,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        item.getTitle(isTr),
                                        style: TextStyle(
                                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                          fontSize: 13.5,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          item.getBody(isTr),
                                          style: const TextStyle(fontSize: 12.5, height: 1.35),
                                        ),
                                      ),
                                      trailing: !item.isRead
                                          ? Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primaryTeal,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          : const Icon(Icons.chevron_right, size: 18),
                                      onTap: () {
                                        modalRef.read(pushNotificationProvider.notifier).markAsRead(item.id);
                                        Navigator.pop(modalCtx);
                                        final targetCandidate = demoCandidates.firstWhere(
                                          (c) => c.id == item.candidateId,
                                          orElse: () => demoCandidates.first,
                                        );
                                        if (item.category == NotificationCategory.chatMessage) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (_) => ChatRoomDemoScreen(candidate: targetCandidate),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (_) =>
                                                  HouseRulesAgreementScreen(candidate: targetCandidate),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showSettingsModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final currentLocale = ref.watch(localeProvider);
        final isTr = currentLocale.languageCode == 'tr';
        final theme = Theme.of(ctx);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isTr ? 'Ayarlar & KVKK' : 'Settings & KVKK',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isTr ? 'Uygulama Dili / Language' : 'App Language / Dil',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Text('🇹🇷', style: TextStyle(fontSize: 24)),
                  title: const Text('Türkçe', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: isTr ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isTr ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                      width: isTr ? 2 : 1,
                    ),
                  ),
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('tr'));
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                  title: const Text('English', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: !isTr ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: !isTr ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                      width: !isTr ? 2 : 1,
                    ),
                  ),
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.verified_user_outlined, color: theme.colorScheme.primary),
                  title: Text(
                    isTr ? 'KVKK & Veri Gizliliği Merkezi' : 'KVKK & Data Privacy Center',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/scenarios/result');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    isTr ? 'Çıkış Yap' : 'Sign Out',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ref.read(authControllerProvider.notifier).signOut();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);
    final isTr = currentLocale.languageCode == 'tr';
    final candidate = demoCandidates[_currentIndex];
    final unreadNotifs = ref.watch(pushNotificationProvider).unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_work_rounded, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              isTr ? 'Roomie Keşfet' : 'Roomie Discovery',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ActionChip(
              avatar: const Icon(Icons.language, size: 16),
              label: Text(
                isTr ? '🇹🇷 TR' : '🇬🇧 EN',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              onPressed: () {
                ref.read(localeProvider.notifier).toggleLocale();
              },
            ),
          ),
          IconButton(
            tooltip: isTr ? 'Anlık Bildirimler' : 'Push Notifications',
            icon: Badge(
              isLabelVisible: unreadNotifs > 0,
              label: Text('$unreadNotifs'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => _showNotificationsModal(context, ref),
          ),
          IconButton(
            tooltip: isTr ? 'KVKK & Veri Gizliliği' : 'KVKK & Data Privacy',
            icon: const Icon(Icons.verified_user_rounded),
            onPressed: () => context.push('/scenarios/result'),
          ),
          IconButton(
            tooltip: isTr ? 'Ayarlar' : 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsModal(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            children: [
              // KVKK Blind Matching Active Bar
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.visibility_off_outlined, size: 16, color: AppColors.primaryTeal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isTr
                            ? 'KVKK Kapalı Kutu Modu: Adayların ve sizin test sonuçlarınız gizlidir; yalnızca sürtüşmesiz ortak yaşam uyumu gösterilir.'
                            : 'KVKK Blind Mode: Your and candidates\' test results are hidden; only friction-free living harmony is shown.',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Candidate Card
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MatchDetailScreen(candidate: candidate),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'cand_${candidate.id}',
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Photo
                          Image.network(
                            candidate.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.person, size: 80),
                            ),
                          ),

                          // Gradient Overlay
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: theme.brightness == Brightness.dark
                                    ? LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.4),
                                          Colors.black.withValues(alpha: 0.95),
                                        ],
                                        stops: const [0.35, 0.6, 1.0],
                                      )
                                    : LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.3),
                                          Colors.black.withValues(alpha: 0.9),
                                        ],
                                        stops: const [0.4, 0.65, 1.0],
                                      ),
                              ),
                            ),
                          ),

                          // KVKK Blind Compatibility Tier Badge Top-Right (No raw test score!)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified_user_rounded, color: Colors.white, size: 15),
                                  const SizedBox(width: 6),
                                  Text(
                                    candidate.getCompatibilityTier(isTr),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Top-Left KVKK Blind Engine Indicator
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lock_outline, color: Colors.white, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    isTr ? 'KVKK Kapalı Kutu Onaylı' : 'KVKK Blind Verified',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom Candidate Public Info
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${candidate.name}, ${candidate.age}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  candidate.getOccupation(isTr),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    _buildChip(Icons.location_on, candidate.district),
                                    _buildChip(
                                      Icons.wallet,
                                      isTr ? '₺${candidate.budget} / ay' : '₺${candidate.budget} / mo',
                                    ),
                                    _buildChip(Icons.home_outlined, candidate.getHousingStatus(isTr)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  isTr
                                      ? '🔒 Test sonuçları KVKK gereği gizlidir • Ortak Ev Kurallarını görmek için dokunun'
                                      : '🔒 Test results hidden per KVKK • Tap to view Blind Shared House Rules',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.md),

              // Action Buttons Row (Pass vs Interested)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton.large(
                      heroTag: 'fab_pass',
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                      elevation: 4,
                      shape: const CircleBorder(),
                      onPressed: _onPass,
                      child: const Icon(Icons.close_rounded, size: 36),
                    ),
                    FloatingActionButton.large(
                      heroTag: 'fab_match',
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shape: const CircleBorder(),
                      onPressed: () => _onInterested(candidate),
                      child: const Icon(Icons.favorite_rounded, size: 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class MatchDetailScreen extends StatelessWidget {
  final RoommateMatchCandidate candidate;

  const MatchDetailScreen({
    super.key,
    required this.candidate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr
              ? '${candidate.name} • KVKK Uyum Özeti'
              : '${candidate.name} • KVKK Harmony Summary',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Candidate Mini Header
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(candidate.photoUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${candidate.name}, ${candidate.age}',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${candidate.getOccupation(isTr)} • ${candidate.district}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTr
                            ? 'Bütçe: ₺${candidate.budget} / ay • ${candidate.getHousingStatus(isTr)}'
                            : 'Budget: ₺${candidate.budget} / mo • ${candidate.getHousingStatus(isTr)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),

            // KVKK Privacy Shield Card
            Card(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shield_rounded, color: theme.colorScheme.primary, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isTr
                                ? 'KVKK Kapalı Kutu (Black-Box) Koruma Kalkanı'
                                : 'KVKK Black-Box Privacy Shield',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isTr
                          ? '6698 sayılı KVKK uyarınca ne kendi test sonuçlarınız ne de ${candidate.name} adlı adayın test puanları, karakter analizleri veya senaryo yanıtları görüntülenebilir. Sistem yalnızca iki profilin kapalı kutu vektörlerini karşılaştırarak aşağıdaki anonim uyum alanlarını doğrulamıştır.'
                          : 'Under KVKK regulations, neither your own test results nor ${candidate.name}\'s test scores, behavioral charts, or raw scenario answers are visible. The blind engine only verifies mutual harmony categories below.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.xl),

            // Publicly Consented Hard Filters
            Text(
              isTr
                  ? 'Doğrulanmış Konut & Kırmızı Çizgi Kriterleri'
                  : 'Verified Housing & Dealbreaker Filters',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: candidate
                  .getVerifiedFilters(isTr)
                  .map(
                    (f) => Chip(
                      avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.primaryTeal),
                      label: Text(f, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: AppDimensions.xl),

            // Blind Harmony Areas
            Text(
              isTr
                  ? 'Kapalı Kutu Motorunca Onaylanan Uyum Alanları'
                  : 'Harmony Areas Verified by Blind Engine',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 8),
            ...candidate
                .getBlindHarmonyAreas(isTr)
                .map((p) => _buildPointRow(Icons.verified_rounded, AppColors.success, p)),

            const SizedBox(height: AppDimensions.xxl),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => HouseRulesAgreementScreen(candidate: candidate),
                  ),
                );
              },
              child: Text(
                isTr ? 'Ev Kurallarını Onayla / Düzenle 📋' : 'Approve / Edit House Rules 📋',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }
}

/// House Rules Agreement Screen (Item 9)
/// Allows 2 matched roommates to approve, edit, or add AI-suggested house rules
/// (quiet hours, dish policy, guest rules, cleaning) before unlocking the chat.
class HouseRulesAgreementScreen extends ConsumerStatefulWidget {
  final RoommateMatchCandidate candidate;

  const HouseRulesAgreementScreen({super.key, required this.candidate});

  @override
  ConsumerState<HouseRulesAgreementScreen> createState() => _HouseRulesAgreementScreenState();
}

class _HouseRulesAgreementScreenState extends ConsumerState<HouseRulesAgreementScreen> {
  late List<HouseRuleItem> _rules;

  @override
  void initState() {
    super.initState();
    _rules = List<HouseRuleItem>.from(widget.candidate.initialHouseRules);
    final userCustomNote = ref.read(scenarioControllerProvider).additionalNotes.trim();
    if (userCustomNote.isNotEmpty) {
      _rules.add(
        HouseRuleItem(
          id: 'user_custom_note',
          category: HouseRuleCategory.cleaningChores,
          textEn: userCustomNote,
          textTr: userCustomNote,
          isAccepted: true,
          isEdited: true,
        ),
      );
    }
  }

  void _openEditRuleDialog(int index, bool isTr) {
    final currentRule = _rules[index];
    final textController = TextEditingController(text: currentRule.getText(isTr));
    final presets = currentRule.getPresets(isTr);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(currentRule.categoryIcon, color: AppColors.primaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isTr
                          ? '${currentRule.getCategoryLabel(isTr)} Kuralını Düzenle'
                          : 'Edit ${currentRule.getCategoryLabel(isTr)} Rule',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isTr ? 'Hızlı AI Uzlaşma Şablonları:' : 'Quick AI Compromise Presets:',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primaryTeal),
              ),
              const SizedBox(height: 8),
              ...presets.map(
                (preset) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      textController.text = preset;
                    },
                    child: Text(
                      preset,
                      style: const TextStyle(fontSize: 12.5, height: 1.35),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isTr ? 'Kural Metni (Düzenlenebilir)' : 'Rule Text (Editable)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final updatedText = textController.text.trim();
                  if (updatedText.isEmpty) return;
                  setState(() {
                    _rules[index] = currentRule.copyWith(
                      textTr: isTr ? updatedText : currentRule.textTr,
                      textEn: !isTr ? updatedText : currentRule.textEn,
                      isEdited: true,
                      isAccepted: true,
                    );
                  });
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  isTr ? 'Kuralı Güncelle & Onayla' : 'Update & Approve Rule',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddCustomRuleDialog(bool isTr) {
    final textController = TextEditingController();
    HouseRuleCategory selectedCategory = HouseRuleCategory.quietHours;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final theme = Theme.of(modalCtx);
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isTr ? 'Yeni Ev Kuralı Ekle' : 'Add Custom House Rule',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(modalCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: HouseRuleCategory.values.map((cat) {
                      final tempItem = HouseRuleItem(
                        id: 'tmp',
                        category: cat,
                        textEn: '',
                        textTr: '',
                      );
                      return ChoiceChip(
                        avatar: Icon(tempItem.categoryIcon, size: 16),
                        label: Text(tempItem.getCategoryLabel(isTr)),
                        selected: selectedCategory == cat,
                        onSelected: (sel) {
                          if (sel) setModalState(() => selectedCategory = cat);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: textController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: isTr
                          ? 'Örn: Hafta içi 23:00 sonrası mutfakta yüksek sesli blender çalıştırılmaması'
                          : 'e.g., No loud appliances in the kitchen after 23:00 on weeknights',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isEmpty) return;
                      setState(() {
                        _rules.add(
                          HouseRuleItem(
                            id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                            category: selectedCategory,
                            textEn: text,
                            textTr: text,
                            isAccepted: true,
                            isEdited: true,
                          ),
                        );
                      });
                      Navigator.pop(modalCtx);
                    },
                    icon: const Icon(Icons.add_task_rounded),
                    label: Text(
                      isTr ? 'Sözleşmeye Ekle' : 'Add to Agreement',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final candidate = widget.candidate;
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    final acceptedRules = _rules.where((r) => r.isAccepted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'Yapay Zeka Ev Kuralları Sözleşmesi' : 'AI House Rules Agreement',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top AI Explanation Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFCCFBF1).withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.handshake_rounded, color: AppColors.primaryTeal, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTr
                              ? 'Sohbet Öncesi Ev Kuralları Uzlaşması'
                              : 'Pre-Chat House Rules Negotiation',
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF115E59),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTr
                              ? '${candidate.name} ile sohbet açılmadan önce; sessizlik saatleri, bulaşık politikası ve misafir kuralları gibi AI tarafından önerilen kuralları onaylayabilir veya kalem ikonuna dokunarak düzenleyebilirsiniz.'
                              : 'Before unlocking chat with ${candidate.name}, approve or tap the edit icon to customize AI-suggested rules on quiet hours, dish policy, and guest rules.',
                          style: const TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF115E59)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isTr
                      ? 'Önerilen Yaşam Kuralları (${acceptedRules.length}/${_rules.length} Onaylı)'
                      : 'Proposed Guidelines (${acceptedRules.length}/${_rules.length} Approved)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _openAddCustomRuleDialog(isTr),
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: Text(
                    isTr ? 'Kural Ekle' : 'Add Rule',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Categorized Editable Rules List
            ...List.generate(_rules.length, (index) {
              final rule = _rules[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: rule.isAccepted
                        ? AppColors.primaryTeal.withValues(alpha: 0.45)
                        : Colors.grey.withValues(alpha: 0.25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(rule.categoryIcon, size: 17, color: AppColors.primaryTeal),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              rule.getCategoryLabel(isTr),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                          ),
                          if (rule.isEdited) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accentWarm.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isTr ? 'Düzenlendi' : 'Edited',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentWarm,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          IconButton(
                            tooltip: isTr ? 'Kuralı Düzenle' : 'Edit Rule',
                            icon: const Icon(Icons.edit_outlined, size: 19, color: AppColors.primaryTeal),
                            onPressed: () => _openEditRuleDialog(index, isTr),
                          ),
                          Checkbox(
                            value: rule.isAccepted,
                            activeColor: AppColors.primaryTeal,
                            onChanged: (val) {
                              setState(() {
                                _rules[index] = rule.copyWith(isAccepted: val ?? false);
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 12, bottom: 4),
                        child: Text(
                          rule.getText(isTr),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                            decoration: rule.isAccepted ? null : TextDecoration.lineThrough,
                            color: rule.isAccepted ? null : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: AppDimensions.lg),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: acceptedRules.isEmpty
                  ? null
                  : () {
                      // Trigger meaningful push notification for accepted house rules
                      ref.read(pushNotificationProvider.notifier).notifyHouseRulesAccepted(
                            candidate.name,
                            acceptedRules.length,
                            candidate.id,
                          );

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => ChatRoomDemoScreen(
                            candidate: candidate,
                            agreedRules: acceptedRules,
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.verified_rounded),
              label: Text(
                isTr
                    ? 'Kuralları Onayla (${acceptedRules.length}) & Sohbete Geç 💬'
                    : 'Approve Rules (${acceptedRules.length}) & Open Chat 💬',
                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomDemoScreen extends ConsumerStatefulWidget {
  final RoommateMatchCandidate candidate;
  final List<HouseRuleItem>? agreedRules;

  const ChatRoomDemoScreen({
    super.key,
    required this.candidate,
    this.agreedRules,
  });

  @override
  ConsumerState<ChatRoomDemoScreen> createState() => _ChatRoomDemoScreenState();
}

class _ChatRoomDemoScreenState extends ConsumerState<ChatRoomDemoScreen> {
  final _msgController = TextEditingController();
  late final List<HouseRuleItem> _activeRules;
  final List<Map<String, String>> _messages = [
    {
      'sender': 'them',
      'text': 'Merhaba! Sessizlik saatleri, bulaşık ve misafir kuralları sözleşmesini onayladığını gördüm, eşleştiğimize çok sevindim! :)',
      'time': '14:20',
    },
    {
      'sender': 'them',
      'text': 'Kadıköy / Moda civarında baktığın evler var mı, yoksa birlikte mi ilanlara bakalım?',
      'time': '14:21',
    },
  ];

  @override
  void initState() {
    super.initState();
    _activeRules = widget.agreedRules ?? widget.candidate.initialHouseRules;
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'me',
        'text': text,
        'time': '14:23',
      });
    });
    _msgController.clear();

    // Auto-reply simulation + Live Push Notification trigger (Item 8)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      const replyTr =
          'Harika! Çok mantıklı. Bu hafta sonu Moda tarafında bir kahve içip hem tanışalım hem de ilanları değerlendirelim!';
      const replyEn =
          'Awesome! Let\'s grab a coffee near Moda this weekend to meet in person and check listings together!';

      setState(() {
        _messages.add({
          'sender': 'them',
          'text': replyTr,
          'time': '14:24',
        });
      });

      ref.read(pushNotificationProvider.notifier).notifyIncomingChatMessage(
            candidateName: widget.candidate.name,
            messagePreviewTr: replyTr,
            messagePreviewEn: replyEn,
            candidateId: widget.candidate.id,
          );
    });
  }

  void _showAgreedRulesSheet(bool isTr) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.handshake_rounded, color: AppColors.primaryTeal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isTr
                            ? 'Üzerinde Uzlaşılan Ev Kuralları (${_activeRules.length})'
                            : 'Mutually Agreed House Rules (${_activeRules.length})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                ..._activeRules.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(r.categoryIcon, size: 18, color: AppColors.primaryTeal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${r.getCategoryLabel(isTr)}: ${r.getText(isTr)}',
                            style: const TextStyle(fontSize: 13.5, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final candidate = widget.candidate;
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: NetworkImage(candidate.photoUrl)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(candidate.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    isTr
                        ? 'Çevrimiçi • ${candidate.getCompatibilityTier(isTr)}'
                        : 'Online • ${candidate.getCompatibilityTier(isTr)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.success),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isTr ? 'Onaylanan Ev Kuralları' : 'Agreed House Rules',
            icon: const Icon(Icons.assignment_turned_in_outlined, color: AppColors.primaryTeal),
            onPressed: () => _showAgreedRulesSheet(isTr),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pinned House Rules Agreement Banner
          InkWell(
            onTap: () => _showAgreedRulesSheet(isTr),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFCCFBF1).withValues(alpha: 0.6),
              child: Row(
                children: [
                  const Icon(Icons.handshake_rounded, size: 18, color: AppColors.primaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isTr
                          ? '📋 ${_activeRules.length} Ortak Ev Kuralı onaylandı (İncelemek için dokun)'
                          : '📋 ${_activeRules.length} Shared House Rules approved (Tap to view)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF115E59),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _sendMessage(
                      isTr
                          ? 'Onayladığımız ortak ev kuralları çerçevesinde taşınma takvimimizi konuşalım mı?'
                          : 'Shall we discuss our move-in timeline based on our agreed house rules?',
                    ),
                    child: Text(
                      isTr ? 'Sor' : 'Ask',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final m = _messages[index];
                final isMe = m['sender'] == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primaryTeal : Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['text']!,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m['time']!,
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black45,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(
                        hintText: isTr ? 'Mesaj yazın...' : 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.primaryTeal),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
