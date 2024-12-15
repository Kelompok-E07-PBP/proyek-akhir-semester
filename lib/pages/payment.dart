import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mujur_reborn/providers/navigation_provider.dart'; // Import the provider

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<dynamic> keranjangItems = [];
  String? city;
  double deliveryFee = 0.0;
  double totalHarga = 0.0;
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    // Delay the fetch to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      fetchData(request);
    });
  }

  Future<void> fetchData(CookieRequest request) async {
    try {
      final response = await request.get('http://localhost:8000/keranjang/json/');
      print('Response body: $response');
      setState(() {
        keranjangItems = response['items'] ?? [];
        city = response['pengiriman']?['city'];
        deliveryFee = response['delivery_fee']?.toDouble() ?? 0.0;
        totalHarga = response['total']?.toDouble() ?? 0.0;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> processPayment(CookieRequest request) async {
    if (selectedPaymentMethod == null) {
      showErrorDialog('Silakan pilih metode pembayaran.');
      return;
    }

    try {
      final response = await request.post(
        'http://localhost:8000/pembayaran/process/',
        {'payment_method': selectedPaymentMethod},
      );

      if (response['message'] == 'Payment successful!') {
        showSuccessDialog('Pembayaran berhasil dilakukan!');
      } else if (response['error'] != null) {
        showErrorDialog(response['error']);
      }
    } catch (e) {
      print('Error: $e');
      showErrorDialog('Terjadi kesalahan saat melakukan pembayaran.');
    }
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Use NavigationProvider to switch to Home tab or any other desired tab
              Provider.of<NavigationProvider>(context, listen: false).setIndex(0);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: keranjangItems.isEmpty
          ? const Center(child: Text('Keranjang Anda kosong.'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... [Existing Table and Details Code]

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Metode Pembayaran:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        RadioListTile(
                          title: const Text('Kartu Kredit'),
                          value: 'Kartu Kredit',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Kartu Debit'),
                          value: 'Kartu Debit',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Transfer Bank'),
                          value: 'Transfer Bank',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('E-Wallet'),
                          value: 'E-Wallet',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => processPayment(request),
                          child: const Text('Bayar', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
