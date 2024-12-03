import 'package:flutter/material.dart';
import 'package:mujur_reborn/widgets/slidiing_banner';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SlidingBanner(
            images: [
              'assets/images/banner1.png',
              'assets/images/banner2.png',
              'assets/images/banner3.png',
            ], // Pass your images here
          ),
          Expanded(
            child: Center(
              child: Text('Home Page Content Here'),
            ),
          ),
        ],
      ),
    );
  }
}
