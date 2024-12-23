// lib/main.dart

import 'package:flutter/material.dart';
import 'package:mujur_reborn/pages/login.dart';
import 'package:mujur_reborn/widgets/bottom_navbar.dart'; // Import BottomNavbar
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mujur_reborn/providers/navigation_provider.dart'; // Import the provider

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CookieRequest>(
          create: (_) => CookieRequest(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mujur Reborn',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
      ).copyWith(secondary: Colors.blue[800]),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400]!), // Default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue[800]!), // Focused border color
        ),
      ),
      useMaterial3: true,
    ),

      // Define the initial route
      initialRoute: '/',
      // Define the named routes
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) =>
            const BottomNavbar(), // Main route with BottomNavbar
      },
    );
  }
}
