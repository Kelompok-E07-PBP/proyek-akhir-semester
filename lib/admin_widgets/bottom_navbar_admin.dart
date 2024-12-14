import 'package:flutter/material.dart';
import 'package:mujur_reborn/pages/home_admin.dart';
import 'package:mujur_reborn/pages/login.dart';
import 'package:mujur_reborn/pages/productentry_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BottomNavbarAdmin extends StatefulWidget {
  const BottomNavbarAdmin({super.key});

  @override
  State<BottomNavbarAdmin> createState() => _BottomNavbarAdminState();
}

class _BottomNavbarAdminState extends State<BottomNavbarAdmin> {
  void _addProduct() {
    // Add your add product functionality here
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const ProductEntryFormPage()),
    );
  }

  Future<void> _logout(CookieRequest request) async {
    final response = await request.logout(
        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
        "http://localhost:8000/auth/logout/");
    String message = response["message"];
    if (context.mounted) {
      if (response['status']) {
          String uname = response["username"];
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("$message Sampai jumpa, $uname."),
          ));
          Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
          );
      } 
      else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(message),
              ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      // Top AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              onPressed: (){_logout(request);},
              color: Colors.black,
            ),
          ),
        ],
      ),

      // Single admin page
      body: HomeAdminPage(),

      // Floating Action Button at bottom-right
      floatingActionButton: FloatingActionButton(
        onPressed: (){_addProduct();},
        child: const Icon(Icons.add),
      ),
    );
  }
}
