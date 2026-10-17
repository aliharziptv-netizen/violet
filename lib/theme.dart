import 'package:flutter/material.dart';

const Color kBg = Color(0xFF0A0A0F);
const Color kCard = Color(0xFF16161D);
const Color kPrimary = Color(0xFF8B5CF6);
const Color kPrimaryDark = Color(0xFF5B21B6);

ThemeData buildTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: kBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      brightness: Brightness.dark,
    ).copyWith(primary: kPrimary),
  );
}

const LinearGradient kButtonGradient = LinearGradient(
  colors: [kPrimary, kPrimaryDark],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
