import 'package:flutter/material.dart';
import 'package:mujur_reborn/pages/home_admin.dart';

class BottomNavbarAdmin extends StatefulWidget {
  const BottomNavbarAdmin({super.key});

  @override
  State<BottomNavbarAdmin> createState() => _BottomNavbarAdminState();
}

class _BottomNavbarAdminState extends State<BottomNavbarAdmin> {
  void _addProduct() {
    // Add your add product functionality here
    print("Add product button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        titleSpacing: 20,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Admin logout functionality
                print("logout");
              },
              color: Colors.black,
            ),
          ),
        ],
      ),

      // Single admin page
      body: HomeAdminPage(),

      // Floating Action Button at bottom-right
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
