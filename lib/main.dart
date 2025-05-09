import 'package:emprestabem/core/constants/colors.dart';
import 'package:emprestabem/pages/home/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Empresta Bem Melhor',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: EmprestaColors.orangeEmpresta),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: EmprestaColors.orangeEmpresta,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const Homepage(),
    );
  }
}
