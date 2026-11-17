import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/app_button.dart';
import '../application/scenario_controller.dart';

class LivingStyleResultScreen extends ConsumerWidget {
  const LivingStyleResultScreen({super.key});

  void _showKvkkNoticeModal(BuildContext context, bool isTr) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          isTr
                              ? '6698 Sayılı KVKK Aydınlatma Metni'
                              : 'KVKK / GDPR Data Privacy Notice',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    isTr
                        ? '1. Veri Sorumlusu ve İşleme Amacı\n'
                          'Roomie uygulaması kapsamında yanıtladığınız yaşam senaryoları, 6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) Madde 4, 5 ve 6 uyarınca "Veri Minimizasyonu" ve "Tasarımdan İtibaren Gizlilik (Privacy-by-Design)" ilkelerine uygun olarak işlenmektedir.\n\n'
                          '2. Sonuçların Gösterilmemesi (Profilleme Yasağı ve Mahremiyet)\n'
                          '• Kişisel Sonuç Gizliliği: Test yapan kullanıcıların bireysel davranış puanları, psikolojik arketipleri veya radar grafikleri kullanıcıya gösterilmez.\n'
                          '• Karşı Taraf Gizliliği: Eşleştiğiniz kişilerin test sonuçları, senaryo yanıtları veya bireysel puanları hiçbir şekilde tarafınıza veya üçüncü kişilere açıklanmaz.\n\n'
                          '3. Kapalı Kutu (Black-Box) Eşleştirme Sistemi\n'
                          'Yanıtlarınız yalnızca izole sunucu katmanında tek yönlü matematiksel vektörlere dönüştürülür. Sistem, iki kullanıcının ham verilerini kimseye göstermeden yalnızca "Düşük Sürtüşme Uyumu" bilgisini ve iki tarafın üzerinde anlaşabileceği nötr "Ortak Ev Kuralları" önerilerini üretir.\n\n'
                          '4. KVKK Madde 11 Kapsamındaki Haklarınız\n'
                          'Dilediğiniz zaman bu ekran üzerinden senaryo yanıtlarınızı güncelleyebilir veya "Test Verilerimi Sıfırla & Anonimleştir" butonuyla kapalı kutu vektörünüzü kalıcı olarak silebilirsiniz.'
                        : '1. Purpose & Privacy-by-Design\n'
                          'Your scenario responses are processed strictly under KVKK (Law No. 6698) and GDPR data minimization principles.\n\n'
                          '2. Strict Non-Disclosure of Test Results\n'
                          '• Your Own Results Are Hidden: To prevent psychological profiling exposure, individual test scores, archetypes, and dimension charts are never displayed.\n'
                          '• Matched Candidates\' Results Are Hidden: You can never view the test results, dimension scores, or raw scenario answers of any roommate candidate.\n\n'
                          '3. Black-Box Blind Matching Engine\n'
                          'Responses are converted into isolated server-side vectors solely to filter out high-friction matches and synthesize neutral "Shared House Rules" before chat.\n\n'
                          '4. Your Data Rights (Article 11)\n'
                          'You may update your responses or permanently erase and anonymize your test vector at any time from this screen.',
                    style: const TextStyle(fontSize: 14, height: 1.55),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: isTr ? 'Anladım, Kapat' : 'Understood, Close',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmAnonymizeData(BuildContext context, WidgetRef ref, bool isTr) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isTr ? 'Verileri Sıfırla & Anonimleştir' : 'Reset & Anonymize Test Data',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isTr
              ? 'KVKK Madde 7 ve 11 kapsamındaki unutulma hakkınız doğrultusunda tüm senaryo yanıtlarınız ve kapalı kutu uyum vektörünüz silinecektir. Onaylıyor musunuz?'
              : 'Under your KVKK right to erasure, all your scenario answers and your blind compatibility vector will be permanently cleared. Do you confirm?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isTr ? 'Vazgeç' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(scenarioControllerProvider.notifier).anonymizeAndResetTestData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isTr
                        ? 'Test verileriniz KVKK kapsamında sıfırlandı ve anonimleştirildi.'
                        : 'Your test data has been reset and anonymized under KVKK.',
                  ),
                ),
              );
              context.go('/scenarios');
            },
            child: Text(isTr ? 'Evet, Verilerimi Sil' : 'Yes, Delete My Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scenarioControllerProvider);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isTr = locale == 'tr';

    final result = state.result;
    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isTr ? 'KVKK & Veri Gizliliği' : 'KVKK & Data Privacy'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  isTr
                      ? 'Henüz kapalı kutu uyum vektörünüz oluşturulmadı.'
                      : 'Your blind compatibility vector has not been generated yet.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: isTr ? 'Senaryo Testine Git' : 'Go to Scenario Test',
                  onPressed: () => context.go('/scenarios'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTr ? 'KVKK Korumalı Eşleşme Sistemi' : 'KVKK Blind Matching System',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // KVKK Black-Box Verification Card (Replaces personal test result exposure)
              Card(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_user_rounded,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isTr
                              ? '6698 SAYILI KVKK KAPALI KUTU MODU AKTİF'
                              : 'KVKK / GDPR BLACK-BOX PRIVACY ACTIVE',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isTr
                            ? 'Yanıtlarınız Şifrelendi ve İzole Edildi'
                            : 'Your Responses Are Encrypted & Isolated',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isTr
                            ? 'KVKK uyumluluğu gereği test yapan kişilerin kendi test sonuçları ve eşleştiği kişilerin test sonuçları hiçbir ekranda gösterilmez. Yanıtlarınız yalnızca arka planda güvenli uyum hesaplaması için kullanılır.'
                            : 'In compliance with KVKK privacy laws, neither your own test results nor the test results of your matches are ever displayed. Your responses are processed strictly in the background.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.9),
                          height: 1.45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock_outline_rounded, size: 18, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                isTr
                                    ? '${result.answeredCount} senaryo işlendi • Kişisel sonuç gösterimi kapalı'
                                    : '${result.answeredCount} scenarios processed • Personal result display disabled',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.xl),

              if (state.additionalNotes.trim().isNotEmpty) ...[
                Card(
                  elevation: 0,
                  color: AppColors.primaryTeal.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    side: BorderSide(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.edit_note_rounded, color: AppColors.primaryTeal, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTr
                                    ? 'Eklediğiniz Özel Kural / Dikkat Notu:'
                                    : 'Your Custom Rule / Important Note:',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.additionalNotes,
                                style: const TextStyle(fontSize: 13.5, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
              ],

              // Explanation of the New KVKK System
              Text(
                isTr
                    ? 'KVKK Uyumlu Yeni Sistem Nasıl Çalışır?'
                    : 'How Does the KVKK-Compliant System Work?',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimensions.md),

              _buildPrivacyPillarCard(
                theme: theme,
                icon: Icons.visibility_off_rounded,
                color: AppColors.primaryTeal,
                title: isTr
                    ? '1. Kendi Sonuçlarınız Gösterilmez'
                    : '1. No Personal Profiling Display',
                description: isTr
                    ? 'Bireysel puanlama, psikolojik karakter etiketleme veya boyut grafikleri KVKK profilleme ilkeleri gereği kullanıcıya sunulmaz.'
                    : 'Individual dimension scores, psychological labels, and radar charts are hidden to prevent invasive personal profiling.',
              ),
              const SizedBox(height: AppDimensions.sm),
              _buildPrivacyPillarCard(
                theme: theme,
                icon: Icons.shield_rounded,
                color: AppColors.secondaryIndigo,
                title: isTr
                    ? '2. Eşleştiğiniz Kişilerin Sonuçları Gizlidir'
                    : '2. Candidate Test Results Are Strictly Hidden',
                description: isTr
                    ? 'Eşleştiğiniz kişilerin hangi senaryoya ne yanıt verdiği veya test puanları size gösterilmez; sizin sonuçlarınız da onlara gösterilmez.'
                    : 'Neither you nor your matched candidates can view each other\'s test scores, radar graphs, or raw scenario responses.',
              ),
              const SizedBox(height: AppDimensions.sm),
              _buildPrivacyPillarCard(
                theme: theme,
                icon: Icons.handshake_rounded,
                color: AppColors.success,
                title: isTr
                    ? '3. Anonim Ortak Ev Kuralları Sentezi'
                    : '3. Blind Shared House Rules Synthesis',
                description: isTr
                    ? 'Kapalı kutu algoritması yalnızca yüksek sürtüşme riskini filtreler ve sohbet öncesi iki tarafın onaylayacağı nötr "Ortak Ev Kuralları" önerir.'
                    : 'The blind algorithm filters high-friction pairs and generates neutral "Shared House Rules" for mutual approval before chatting.',
              ),

              const SizedBox(height: AppDimensions.xl),

              // KVKK Rights Box
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.description_outlined, size: 20),
                label: Text(
                  isTr
                      ? 'KVKK Aydınlatma Metni ve Veri İlkelerini Oku'
                      : 'Read KVKK Privacy Notice & Data Principles',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () => _showKvkkNoticeModal(context, isTr),
              ),

              const SizedBox(height: AppDimensions.xl),

              // Action Buttons
              AppButton(
                text: isTr ? 'Uyumlu Adayları Keşfet' : 'Explore Compatible Candidates',
                onPressed: () => context.go('/discover'),
              ),
              const SizedBox(height: AppDimensions.sm),
              AppButton(
                text: isTr ? 'Yanıtlarımı Güncelle (Testi Yeniden Çöz)' : 'Update My Responses (Retake Test)',
                variant: AppButtonVariant.text,
                onPressed: () {
                  ref.read(scenarioControllerProvider.notifier).retakeTest();
                  context.go('/scenarios');
                },
              ),
              const SizedBox(height: AppDimensions.xs),
              TextButton.icon(
                onPressed: () => _confirmAnonymizeData(context, ref, isTr),
                icon: const Icon(Icons.delete_forever_outlined, color: AppColors.error, size: 18),
                label: Text(
                  isTr
                      ? 'KVKK Kapsamında Test Verilerimi Sıfırla & Anonimleştir'
                      : 'Reset & Anonymize My Test Data (KVKK Right to Erasure)',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPillarCard({
    required ThemeData theme,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
