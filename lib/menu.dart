
import 'package:flutter/material.dart';
import 'package:mujur_reborn/widgets/left_drawer.dart';


class MyHomePage extends StatelessWidget {
    const MyHomePage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        // Judul aplikasi "Mental Health Tracker" dengan teks putih dan tebal.
        title: const Text(
          'Mujur Reborn',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          
        ),
        // Warna latar belakang AppBar diambil dari skema warna tema aplikasi.
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        ),
      drawer: const LeftDrawer(),
      );
    }
}