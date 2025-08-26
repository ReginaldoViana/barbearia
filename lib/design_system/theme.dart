import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class BarberTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: BarberColors.primary,
          secondary: BarberColors.secondary,
          background: BarberColors.background,
          surface: BarberColors.surface,
          onBackground: BarberColors.onBackground,
          onSurface: BarberColors.onSurface,
          onPrimary: BarberColors.onPrimary,
        ),
        scaffoldBackgroundColor: BarberColors.background,
        cardColor: BarberColors.cardColor,
        appBarTheme: AppBarTheme(
          backgroundColor: BarberColors.surface,
          foregroundColor: BarberColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: BarberColors.primary),
        ),
        textTheme: TextTheme(
          displayLarge: BarberTextStyles.displayLarge,
          displayMedium: BarberTextStyles.displayMedium,
          displaySmall: BarberTextStyles.displaySmall,
          headlineLarge: BarberTextStyles.headlineLarge,
          headlineMedium: BarberTextStyles.headlineMedium,
          headlineSmall: BarberTextStyles.headlineSmall,
          titleLarge: BarberTextStyles.titleLarge,
          titleMedium: BarberTextStyles.titleMedium,
          titleSmall: BarberTextStyles.titleSmall,
          bodyLarge: BarberTextStyles.bodyLarge,
          bodyMedium: BarberTextStyles.bodyMedium,
          bodySmall: BarberTextStyles.bodySmall,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: BarberColors.surface,
          selectedItemColor: BarberColors.primary,
          unselectedItemColor: BarberColors.unselectedItem,
          selectedLabelStyle: BarberTextStyles.selectedChipLabel,
          unselectedLabelStyle: BarberTextStyles.chipLabel,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: BarberColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: BarberColors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: BarberColors.primary, width: 2),
          ),
        ),
      );
}
