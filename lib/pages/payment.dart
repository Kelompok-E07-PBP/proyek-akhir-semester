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
  bool isLoading = false;
  bool isFetchingData = true; // Tambahkan variabel ini

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchData(request);
  }

  Future<void> fetchData(CookieRequest request) async {
    setState(() {
      isFetchingData = true; // Mulai pemuatan data
    });
    try {
      final response = await request.get('http://localhost:8000/keranjang/json/');
      setState(() {
        keranjangItems = response['items'] ?? [];
        city = response['pengiriman']?['city'];
        deliveryFee = response['delivery_fee'] ?? 0.0;
        totalHarga = response['total'] ?? 0.0;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data keranjang')),
      );
    } finally {
      setState(() {
        isFetchingData = false; // Selesai pemuatan data
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isFetchingData) {
      // Data masih dimuat
      return const Center(child: CircularProgressIndicator());
    } else if (keranjangItems.isEmpty) {
      // Keranjang kosong
      return _buildEmptyCart();
    } else {
      // Tampilkan keranjang
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _buildCartTable(),
            const SizedBox(height: 16),
            _buildTotalHargaSection(),
            const SizedBox(height: 16),
            _buildPaymentMethods(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : () => processPayment(context.read<CookieRequest>()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Bayar',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Keranjang Kosong',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
        ],
      ),
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
        _buildCell('Rp ${item['price']}'),
        _buildCell('${item['quantity']}'),
        _buildCell('Rp ${item['subtotal']}'),
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
          _buildPriceRow('Delivery Fee', 'Rp $deliveryFee'),
          const Divider(color: Colors.grey),
          _buildPriceRow('Total Harga', 'Rp $totalHarga', isBold: true),
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
