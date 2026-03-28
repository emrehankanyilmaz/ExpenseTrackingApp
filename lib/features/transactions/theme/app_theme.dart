import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          displaySmall: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          headlineLarge: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          headlineMedium: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          headlineSmall: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          titleLarge: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          titleMedium: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
          titleSmall: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          bodyLarge: TextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
          bodyMedium: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          bodySmall: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
          labelLarge: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          labelMedium: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
          labelSmall: TextStyle(
              fontSize: 9.5, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      );
}
