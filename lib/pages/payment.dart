import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mujur_reborn/widgets/button.dart';
import 'package:mujur_reborn/widgets/empty_cart.dart';
import 'package:mujur_reborn/widgets/empty_shipping.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mujur_reborn/widgets/checkout_progress.dart'; // Add this

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<dynamic> keranjangItems = [];
  String? city;
  double deliveryFee = 0.0;
  double totalHarga = 0.0;
  String? selectedPaymentMethod;
  bool isLoading = false;
  bool isFetchingData = true;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchData(request);
  }

  Future<void> fetchData(CookieRequest request) async {
    setState(() {
      isFetchingData = true;
    });
    try {
      // Ambil data keranjang dan pengiriman
      final response = await request.get('http://localhost:8000/pembayaran/keranjang-pengiriman/json');

      setState(() {
        keranjangItems = response['keranjang']['items'] ?? [];
        city = response['pengiriman']?['city'];
        deliveryFee = response['pengiriman']?['delivery_fee'] ?? 0.0;
        totalHarga = response['total_harga'] ?? 0.0;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data keranjang dan pengiriman')),
      );
    } finally {
      setState(() {
        isFetchingData = false;
      });
    }
  }

  Future<void> processPayment(CookieRequest request) async {
    if (selectedPaymentMethod == null) {
      showErrorDialog("Silakan pilih metode pembayaran.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await request.post(
        'http://localhost:8000/pembayaran/pembayaran/process/',
        {'payment_method': selectedPaymentMethod},
      );

      if (response['message'] == 'Payment successful!') {
        showSuccessDialog("Pembayaran berhasil dilakukan!");
      } else {
        showErrorDialog(response['error'] ?? 'Gagal memproses pembayaran.');
      }
    } catch (e) {
      print('Error: $e');
      showErrorDialog("Terjadi kesalahan saat memproses pembayaran.");
    } finally {
      setState(() {
        isLoading = false;
      });
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
              Navigator.of(context).pushReplacementNamed('/main');
            },
            child: const Text('OK'),
          ),
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
          ),
        ],
      ),
    );
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat("#,##0", "id_ID");
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isFetchingData
          ? const Center(child: CircularProgressIndicator())
          : keranjangItems.isEmpty
              ? _buildEmptyCart()
              : city == null
                  ? _buildEmptyShipping()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CheckoutProgress(currentStep: 2),
                          ),
                          const SizedBox(height: 16),
                          _buildCartTable(),
                          const SizedBox(height: 16),
                          _buildTotalHargaSection(),
                          const SizedBox(height: 16),
                          _buildPaymentMethods(),
                          Center(
                            child: CustomButton(
                              text: 'Bayar',
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? () {}
                                  : () => processPayment(context.read<CookieRequest>()),
                              backgroundColor: Theme.of(context).primaryColor,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              width: 250, 
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildEmptyCart() {
    return const EmptyCartWidget(
      message: 'Keranjang belanja Anda kosong',

    );

  }


  Widget _buildEmptyShipping() {
    return const EmptyShipping(
      message: "Data Pengiriman Tidak Tersedia"
      );
  }

  Widget _buildCartTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        border: TableBorder.all(color: Colors.grey, width: 1),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(2),
        },
        children: [
          _buildTableHeader(),
          ...keranjangItems.map((item) {
            return _buildTableRow(item);
          }).toList(),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.lightBlue),
      children: [
        _buildHeaderCell('Produk'),
        _buildHeaderCell('Harga Satuan'),
        _buildHeaderCell('Jumlah'),
        _buildHeaderCell('Subtotal'),
      ],
    );
  }

  Widget _buildHeaderCell(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildTableRow(Map<String, dynamic> item) {
    return TableRow(
      children: [
        _buildCell(item['product_name']),
        _buildCell('Rp ${formatCurrency(item['price'])}'),
        _buildCell('${item['quantity']}'),
        _buildCell('Rp ${formatCurrency(item['subtotal'])}'),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  Widget _buildTotalHargaSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildPriceRow('Delivery City', city ?? '-'),
          _buildPriceRow('Delivery Fee', 'Rp ${formatCurrency(deliveryFee)}'),
          const Divider(color: Colors.grey),
          _buildPriceRow('Total Harga', 'Rp ${formatCurrency(totalHarga)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildRadioOption('Kartu Kredit'),
        _buildRadioOption('Kartu Debit'),
        _buildRadioOption('Transfer Bank'),
        _buildRadioOption('E-Wallet'),
      ],
    );
  }

  Widget _buildRadioOption(String method) {
    return Center(
      child: SizedBox(
        width: 300,
        child: RadioListTile(
          title: Center(child: Text(method)),
          value: method,
          groupValue: selectedPaymentMethod,
          onChanged: (value) => setState(() => selectedPaymentMethod = value),
        ),
      ),
    );
  }
}
