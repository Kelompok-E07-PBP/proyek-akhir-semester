import 'package:flutter/material.dart';
import 'package:mujur_reborn/widgets/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mujur Reborn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightBlue,
        ).copyWith(secondary: Colors.lightBlue[400]),
        useMaterial3: true,
      ),
      home: const BottomNavbar(), // Use BottomNavbar as the main widget
    );
  }
}
