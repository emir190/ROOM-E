import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Helper utilities for Turkish characters (UTF-8 input & search normalization)
class TurkishTextUtils {
  TurkishTextUtils._();

  static const List<String> turkishChars = [
    'ç',
    'ğ',
    'ı',
    'i',
    'ö',
    'ş',
    'ü',
    'Ç',
    'Ğ',
    'İ',
    'I',
    'Ö',
    'Ş',
    'Ü',
  ];

  /// Converts Turkish string to lowercase properly ('İ' -> 'i', 'I' -> 'ı')
  static String toLowerTurkish(String input) {
    return input
        .replaceAll('İ', 'i')
        .replaceAll('I', 'ı')
        .replaceAll('Ğ', 'ğ')
        .replaceAll('Ü', 'ü')
        .replaceAll('Ş', 'ş')
        .replaceAll('Ö', 'ö')
        .replaceAll('Ç', 'ç')
        .toLowerCase();
  }

  /// Normalizes Turkish characters to ASCII equivalents so both Turkish and English
  /// keyboard inputs match (e.g. 'kadikoy' matches 'Kadıköy', 'isparta' matches 'Isparta')
  static String normalizeForSearch(String input) {
    return toLowerTurkish(input)
        .replaceAll('i̇', 'i')
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  /// Inserts [charToInsert] at the current cursor selection of [controller]
  static void insertChar(
    TextEditingController controller,
    String charToInsert, {
    ValueChanged<String>? onChanged,
  }) {
    final text = controller.text;
    final selection = controller.selection;

    String newText;
    int newOffset;

    if (selection.isValid && selection.start >= 0 && selection.end <= text.length) {
      newText = text.replaceRange(selection.start, selection.end, charToInsert);
      newOffset = selection.start + charToInsert.length;
    } else {
      newText = text + charToInsert;
      newOffset = newText.length;
    }

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );

    onChanged?.call(newText);
  }
}

/// Sleek quick-insert bar for Turkish characters (ç, ğ, ı, İ, ö, ş, ü)
/// Works seamlessly on Android Emulators and English keyboards.
class TurkishCharBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const TurkishCharBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 36,
      margin: const EdgeInsets.only(top: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: TurkishTextUtils.turkishChars.length,
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemBuilder: (context, index) {
          final ch = TurkishTextUtils.turkishChars[index];
          return Material(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => TurkishTextUtils.insertChar(
                controller,
                ch,
                onChanged: onChanged,
              ),
              child: Container(
                constraints: const BoxConstraints(minWidth: 34),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryTeal.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  ch,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
