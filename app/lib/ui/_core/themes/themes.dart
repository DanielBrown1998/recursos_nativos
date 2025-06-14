import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/ui/_core/themes/colors.dart';

ThemeData appThemeLight = ThemeData.light().copyWith(
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.black),
    ),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.black),
      iconColor: WidgetStatePropertyAll(Colors.black),
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.black),
      iconColor: WidgetStatePropertyAll(Colors.black),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.orange,
  ),
);
