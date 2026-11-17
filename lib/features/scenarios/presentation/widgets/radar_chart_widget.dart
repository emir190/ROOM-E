import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/services/living_style_analyzer.dart';

class RadarChartWidget extends StatelessWidget {
  final Map<String, double> dimensionScores;
  final Map<String, double>? comparisonScores; // For dual overlaid charts
  final String? comparisonLabel;

  const RadarChartWidget({
    super.key,
    required this.dimensionScores,
    this.comparisonScores,
    this.comparisonLabel,
  });

  String _getDimensionTitle(BuildContext context, String key) {
    final lang = Localizations.localeOf(context).languageCode;
    final isTr = lang == 'tr';

    return switch (key) {
      'cleanliness' => isTr ? 'Temizlik' : 'Clean',
      'noise_tolerance' => isTr ? 'Gürültü' : 'Noise',
      'sleep_schedule' => isTr ? 'Uyku' : 'Sleep',
      'social_energy' => isTr ? 'Sosyal' : 'Social',
      'guest_policy' => isTr ? 'Misafir' : 'Guest',
      'chore_fairness' => isTr ? 'İş Bölümü' : 'Chores',
      'money_style' => isTr ? 'Bütçe' : 'Money',
      'conflict_style' => isTr ? 'İletişim' : 'Conflict',
      'privacy_need' => isTr ? 'Özel Alan' : 'Privacy',
      'responsibility' => isTr ? 'Sorumluluk' : 'Reliable',
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const dimensions = LivingStyleAnalyzer.allDimensions;

    final userEntries = dimensions.map((dim) {
      final val = dimensionScores[dim] ?? 50.0;
      return RadarEntry(value: val);
    }).toList();

    final dataSets = <RadarDataSet>[
      RadarDataSet(
        fillColor: AppColors.primaryTeal.withValues(alpha: isDark ? 0.45 : 0.28),
        borderColor: AppColors.primaryTealLight,
        entryRadius: 3.5,
        borderWidth: 2.5,
        dataEntries: userEntries,
      ),
    ];

    if (comparisonScores != null) {
      final comparisonEntries = dimensions.map((dim) {
        final val = comparisonScores![dim] ?? 50.0;
        return RadarEntry(value: val);
      }).toList();

      dataSets.add(
        RadarDataSet(
          fillColor: AppColors.secondaryIndigoLight.withValues(alpha: isDark ? 0.45 : 0.25),
          borderColor: AppColors.secondaryIndigoLight,
          entryRadius: 3.5,
          borderWidth: 2.5,
          dataEntries: comparisonEntries,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.15,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBorderData: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.5,
          ),
          gridBorderData: BorderSide(
            color: isDark
                ? AppColors.borderDark.withValues(alpha: 0.5)
                : AppColors.borderLight.withValues(alpha: 0.8),
            width: 1,
          ),
          tickBorderData: BorderSide(
            color: isDark
                ? AppColors.borderDark.withValues(alpha: 0.3)
                : AppColors.borderLight.withValues(alpha: 0.5),
            width: 1,
          ),
          tickCount: 4,
          ticksTextStyle: TextStyle(
            fontSize: 9,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          titleTextStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          getTitle: (index, angle) {
            if (index >= 0 && index < dimensions.length) {
              return RadarChartTitle(
                text: _getDimensionTitle(context, dimensions[index]),
                angle: angle,
              );
            }
            return const RadarChartTitle(text: '');
          },
          dataSets: dataSets,
        ),
      ),
    );
  }
}
