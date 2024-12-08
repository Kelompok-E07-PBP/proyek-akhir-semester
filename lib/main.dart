import 'package:flutter/material.dart';
import 'package:mujur_reborn/admin_widgets/bottom_navbar_admin.dart';
import 'package:mujur_reborn/pages/login.dart';
import 'package:mujur_reborn/widgets/bottom_navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Mujur Reborn',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.lightBlue,
          ).copyWith(secondary: Colors.lightBlue[400]),
          useMaterial3: true,
        ),
        home: const LoginPage(), // Use BottomNavbar as the main widget
      )
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//       create: (_) {
//         CookieRequest request = CookieRequest();
//         return request;
//       },
//       child: MaterialApp(
//         title: 'Mental Health Tracker',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSwatch(
//             primarySwatch: Colors.deepPurple,
//           ).copyWith(secondary: Colors.deepPurple[400]),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }
