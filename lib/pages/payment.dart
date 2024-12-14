import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
    final request = context.read<CookieRequest>();
    fetchData(request);
  }

  Future<void> fetchData(CookieRequest request) async {
    try {
      final response = await request.get('http://localhost:8000/keranjang/json/');
      print('Response body: $response');
      setState(() {
        keranjangItems = response['items'] ?? [];
        city = response['pengiriman']?['city'];
        deliveryFee = response['delivery_fee'] ?? 0.0;
        totalHarga = response['total'] ?? 0.0;
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
        title: Text('Berhasil!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/main');
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
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
        title: Text('Pembayaran'),
      ),
      body: keranjangItems.isEmpty
          ? Center(child: Text('Keranjang Anda kosong.'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Produk', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Harga Satuan', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Jumlah', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Subtotal', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        ...keranjangItems.map((item) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item['product_name'], textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Rp ${item['price']}', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item['quantity']}', textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Rp ${item['subtotal']}', textAlign: TextAlign.center),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery City:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(city ?? ''),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Fee:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Rp $deliveryFee'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Harga:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Rp $totalHarga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Metode Pembayaran:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        RadioListTile(
                          title: Text('Kartu Kredit'),
                          value: 'Kartu Kredit',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Kartu Debit'),
                          value: 'Kartu Debit',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Transfer Bank'),
                          value: 'Transfer Bank',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('E-Wallet'),
                          value: 'E-Wallet',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentMethod = value as String?;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => processPayment(request),
                          child: Text('Bayar', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                          SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

