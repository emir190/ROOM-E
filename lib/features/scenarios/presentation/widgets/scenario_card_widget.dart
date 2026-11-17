import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/entities/scenario_option.dart';
import '../../domain/entities/user_answer.dart';

class ScenarioCardWidget extends StatelessWidget {
  final Scenario scenario;
  final String? selectedOptionId;
  final ImportanceWeight selectedImportance;
  final ValueChanged<String> onOptionSelected;
  final ValueChanged<ImportanceWeight> onImportanceSelected;

  const ScenarioCardWidget({
    super.key,
    required this.scenario,
    required this.selectedOptionId,
    required this.selectedImportance,
    required this.onOptionSelected,
    required this.onImportanceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Scenario Situation Card
          Card(
            color: theme.colorScheme.surface,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              side: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          scenario.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    scenario.getLocalizedTitle(locale),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    scenario.getLocalizedSituation(locale),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Options List
          ...scenario.options.map((option) {
            final isSelected = selectedOptionId == option.id;
            return _buildOptionTile(context, option, isSelected, locale);
          }),

          const SizedBox(height: AppDimensions.md),

          // Importance Selector
          if (selectedOptionId != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                l10n.importanceQuestion,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                _buildImportanceChip(
                  context: context,
                  label: l10n.importanceNotMuch,
                  value: ImportanceWeight.notMuch,
                  isSelected: selectedImportance == ImportanceWeight.notMuch,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                _buildImportanceChip(
                  context: context,
                  label: l10n.importanceImportant,
                  value: ImportanceWeight.important,
                  isSelected: selectedImportance == ImportanceWeight.important,
                  color: theme.colorScheme.primaryContainer,
                ),
                _buildImportanceChip(
                  context: context,
                  label: l10n.importanceDealbreaker,
                  value: ImportanceWeight.dealbreaker,
                  isSelected: selectedImportance == ImportanceWeight.dealbreaker,
                  color: const Color(0xFFFFEDD5), // Soft orange/warning
                ),
              ],
            ),
          ],
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    ScenarioOption option,
    bool isSelected,
    String locale,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: InkWell(
        onTap: () => onOptionSelected(option.id),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 2, right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              Expanded(
                child: Text(
                  option.getLocalizedText(locale),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: theme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImportanceChip({
    required BuildContext context,
    required String label,
    required ImportanceWeight value,
    required bool isSelected,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? (value == ImportanceWeight.dealbreaker
                  ? const Color(0xFF9A3412)
                  : theme.colorScheme.primary)
              : theme.colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onImportanceSelected(value),
      selectedColor: isSelected
          ? (value == ImportanceWeight.dealbreaker
              ? const Color(0xFFFFEDD5)
              : theme.colorScheme.primaryContainer)
          : null,
      side: BorderSide(
        color: isSelected
            ? (value == ImportanceWeight.dealbreaker
                ? const Color(0xFFF97316)
                : theme.colorScheme.primary)
            : theme.colorScheme.outline.withValues(alpha: 0.4),
      ),
    );
  }
}
