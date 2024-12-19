import 'package:flutter/material.dart';
import 'package:mujur_reborn/pages/payment.dart';
import 'package:mujur_reborn/providers/navigation_provider.dart';
import 'package:mujur_reborn/widgets/shipping_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({Key? key}) : super(key: key);

  @override
  _ShippingPageState createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  bool isLoading = false;
  List<dynamic> cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    final request = context.read<CookieRequest>();
    setState(() => isLoading = true);

    try {
      final response = await request.get('http://localhost:8000/keranjang/json/');
      setState(() {
        cartItems = response['items'] ?? [];
      });
    } catch (e) {
      _showErrorDialog('Gagal memuat data keranjang.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _submitShippingForm(Map<String, String> formData) async {
    if (cartItems.isEmpty) {
      _showErrorDialog('Keranjang kosong. Silakan tambahkan item ke keranjang terlebih dahulu.');
      return;
    }

    final request = context.read<CookieRequest>();
    setState(() => isLoading = true);

    try {

      final response = await request.post(
        'http://localhost:8000/pengiriman/process_pengiriman_ajax/',
        formData,
      );

      if (response['message'] != null) {
        _showSuccessDialog(response['message']);
      } else if (response['error'] != null) {
        _showErrorDialog(response['error']);
      } else {
        _showErrorDialog('Terjadi kesalahan tak terduga.');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan saat memproses pengiriman.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // After success, set the BottomNavbar index to Payment (index 3)
              Provider.of<NavigationProvider>(context, listen: false).setIndex(3);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengiriman'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? _buildEmptyCart()
              : ShippingForm(
                  onSubmit: _submitShippingForm,
                ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Keranjang kosong. Silakan tambahkan item ke keranjang.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/cart'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Lanjut Belanja',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
