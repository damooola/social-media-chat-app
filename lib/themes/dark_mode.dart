import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade700,
    secondary: const Color.fromARGB(255, 62, 62, 62),
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade100,
  ),
);
