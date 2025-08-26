import 'package:flutter/material.dart';
import 'colors.dart';

class BarberDecorations {
  static BoxDecoration dropdownDecoration(BuildContext context) => BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: BarberColors.surface,
    borderRadius: BorderRadius.circular(8),
  );
}
