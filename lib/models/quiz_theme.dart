import 'package:flutter/material.dart';

class QuizThemeConfig {
  final String? backgroundImage;
  final Color baseTextColor;
  final Color unselectedOptionBg;
  final Color selectedOptionBg;
  final Color selectedOptionText;
  final Color selectedOptionBorder;
  final Color unselectedOptionBorder;
  final Color unselectedOptionText;

  const QuizThemeConfig({
    this.backgroundImage,
    required this.baseTextColor,
    required this.unselectedOptionBg,
    required this.selectedOptionBg,
    required this.selectedOptionText,
    required this.selectedOptionBorder,
    required this.unselectedOptionBorder,
    required this.unselectedOptionText,
  });
}
