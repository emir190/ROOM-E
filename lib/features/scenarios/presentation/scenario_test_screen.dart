import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../application/scenario_controller.dart';
import 'widgets/scenario_card_widget.dart';

class ScenarioTestScreen extends ConsumerStatefulWidget {
  const ScenarioTestScreen({super.key});

  @override
  ConsumerState<ScenarioTestScreen> createState() => _ScenarioTestScreenState();
}

class _ScenarioTestScreenState extends ConsumerState<ScenarioTestScreen> {
  late final TextEditingController _additionalNotesController;

  @override
  void initState() {
    super.initState();
    final initialNotes = ref.read(scenarioControllerProvider).additionalNotes;
    _additionalNotesController = TextEditingController(text: initialNotes);
  }

  @override
  void dispose() {
    _additionalNotesController.dispose();
    super.dispose();
  }

  void _showFinishWithNotesModal(BuildContext context, ScenarioController controller, bool isTr) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isTr
                          ? 'Eklemek İstediğiniz Kurallar / Dikkat Edilmesi Gerekenler'
                          : 'Additional House Rules / Important Notes',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isTr
                    ? 'Testi tamamlamadan önce ev arkadaşlığında özellikle dikkat edilmesini istediğiniz bir kural veya not varsa aşağıya yazabilirsiniz (isteğe bağlı):'
                    : 'Before completing the test, you may add any custom rules or important points you want your future roommate to know (optional):',
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _additionalNotesController,
                maxLines: 3,
                onChanged: controller.updateAdditionalNotes,
                decoration: InputDecoration(
                  hintText: isTr
                      ? 'Örn: Hafta içi 23:30 sonrası mutfakta gürültü yapılmaması, ortak giderlerin ayın 1\'inde ödenmesi...'
                      : 'e.g., No loud kitchen noise after 23:30 on weekdays, utilities settled on the 1st of each month...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: isTr ? 'Kaydet ve Testi Tamamla' : 'Save & Complete Test',
                onPressed: () {
                  controller.updateAdditionalNotes(_additionalNotesController.text.trim());
                  Navigator.pop(ctx);
                  controller.finishTest();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scenarioControllerProvider);
    final controller = ref.read(scenarioControllerProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    // If test is marked finished, navigate to result screen
    ref.listen(scenarioControllerProvider, (previous, next) {
      if (next.isFinished && next.result != null && !(previous?.isFinished ?? false)) {
        context.push('/scenarios/result');
      }
    });

    if (state.isLoading && state.scenarios.isEmpty) {
      return const Scaffold(
        body: LoadingIndicator(message: 'Senaryolar yükleniyor...'),
      );
    }

    final currentScenario = state.currentScenario;
    if (currentScenario == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Senaryo bulunamadı'),
              const SizedBox(height: 16),
              AppButton(
                text: 'Yeniden Yükle',
                onPressed: () => controller.init(),
              ),
            ],
          ),
        ),
      );
    }

    final currentNum = state.currentIndex + 1;
    final totalNum = state.totalCount;
    final progress = totalNum > 0 ? currentNum / totalNum : 0.0;
    final isLastScenario = state.currentIndex == totalNum - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.scenarioTestTitle,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (state.canUnlockMatching)
            TextButton.icon(
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: Text(l10n.finishTestEarly),
              onPressed: () => _showFinishWithNotesModal(context, controller, isTr),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                    vertical: AppDimensions.xs,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.scenarioProgress(currentNum, totalNum),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ],
            ),

            // KVKK Privacy Notice Banner
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isTr
                          ? 'KVKK Güvencesi: Test yanıtlarınız ve sonuçlarınız ne size ne de eşleştiğiniz kişilere gösterilir; yalnızca şifreli uyum motorunda işlenir.'
                          : 'KVKK Privacy: Your answers and test results are never shown to you or your matches; they are processed strictly inside the blind matching engine.',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Milestone Banner: Unlocked at 15
            if (state.canUnlockMatching && !state.isFinished)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars_rounded, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.quickTestUnlocked,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Card Body
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: ScenarioCardWidget(
                  key: ValueKey(currentScenario.id),
                  scenario: currentScenario,
                  selectedOptionId: state.selectedOptionId,
                  selectedImportance: state.selectedImportance,
                  onOptionSelected: controller.selectOption,
                  onImportanceSelected: controller.selectImportance,
                ),
              ),
            ),

            // Özellik 3: Senaryo Kısmının Sonunda Ekstra Kurallar / Dikkat Edilmesi Gerekenler Metin Kutucuğu
            if (isLastScenario)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  controller: _additionalNotesController,
                  maxLines: 2,
                  onChanged: controller.updateAdditionalNotes,
                  decoration: InputDecoration(
                    labelText: isTr
                        ? 'Eklemek İstediğiniz Kurallar veya Dikkat Edilmesi Gerekenler'
                        : 'Additional Rules or Important Points to Note',
                    hintText: isTr
                        ? 'Örn: Gece 23:30 sonrası sessizlik, mutfak düzeni vb. özel notunuzu yazın...'
                        : 'e.g., Write any custom rules or points to watch out for...',
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),

            // Bottom Actions Bar
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (state.currentIndex > 0) ...[
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(80, AppDimensions.buttonHeight),
                      ),
                      onPressed: controller.goToPrevious,
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: AppDimensions.md),
                  ],
                  Expanded(
                    child: AppButton(
                      text: isLastScenario ? l10n.saveButton : l10n.continueButton,
                      isLoading: state.isLoading,
                      onPressed: state.selectedOptionId != null
                          ? () {
                              if (isLastScenario) {
                                controller.updateAdditionalNotes(
                                  _additionalNotesController.text.trim(),
                                );
                              }
                              controller.submitCurrentAnswer();
                            }
                          : null,
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
