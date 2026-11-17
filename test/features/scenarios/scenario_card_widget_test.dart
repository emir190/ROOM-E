import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomie/core/l10n/app_localizations.dart';
import 'package:roomie/core/theme/app_theme.dart';
import 'package:roomie/features/scenarios/data/seed/scenario_seed_data.dart';
import 'package:roomie/features/scenarios/domain/entities/user_answer.dart';
import 'package:roomie/features/scenarios/presentation/widgets/scenario_card_widget.dart';

void main() {
  final testScenario = ScenarioSeedData.allScenarios.first;

  testWidgets('ScenarioCardWidget displays situation, options, and handles clicks',
      (WidgetTester tester) async {
    String? selectedOpt;
    ImportanceWeight? selectedImp;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        home: Scaffold(
          body: ScenarioCardWidget(
            scenario: testScenario,
            selectedOptionId: selectedOpt,
            selectedImportance: ImportanceWeight.important,
            onOptionSelected: (id) => selectedOpt = id,
            onImportanceSelected: (imp) => selectedImp = imp,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify scenario title and situation
    expect(find.text(testScenario.title['tr']!), findsOneWidget);
    expect(find.text(testScenario.situation['tr']!), findsOneWidget);

    // Verify options are displayed
    for (final opt in testScenario.options) {
      expect(find.text(opt.text['tr']!), findsOneWidget);
    }

    // Tap first option
    final firstOptionFinder = find.text(testScenario.options.first.text['tr']!);
    await tester.tap(firstOptionFinder);
    await tester.pumpAndSettle();

    expect(selectedOpt, testScenario.options.first.id);
    expect(selectedImp, isNull);
  });
}
