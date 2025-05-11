import 'package:flutter/material.dart';
import 'package:mini_project_mobile/pages/splash_page.dart';
import 'theme.dart';
import 'pages/splash_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // Initialize date formatting for Indonesia locale
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCash',
      debugShowCheckedModeBanner: false,
      theme: myCashTheme,
      home: const SplashPage(),
    );
  }
}