import 'package:flutter/material.dart';

final ThemeData myCashTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFFE8F5E9),
  primaryColor: Color(0xFF0057B8),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF0057B8),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Color(0xFF0D1B2A), fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Color(0xFF6C757D), fontSize: 16),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);
