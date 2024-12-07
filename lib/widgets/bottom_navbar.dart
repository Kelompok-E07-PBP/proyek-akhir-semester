import 'package:flutter/material.dart';
import 'package:mujur_reborn/pages/cart.dart';
import 'package:mujur_reborn/pages/home.dart';
import 'package:mujur_reborn/pages/payment.dart';
import 'package:mujur_reborn/pages/shipping.dart';
import 'package:mujur_reborn/pages/review.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const CartPage(),
    const ShippingPage(),
    const PaymentPage(),
    const ReviewPage(),
  ];

  void _logout() {
    // Add your logout functionality here
    print("Logout button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png', 
              height: 40, 
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Add right margin
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.shopping_cart_outlined),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.local_shipping_outlined),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.payments_outlined),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.rate_review_outlined),
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
