import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mujur_reborn/models/cart_model.dart';
import 'package:mujur_reborn/pages/cart_form.dart';
import 'package:mujur_reborn/providers/navigation_provider.dart'; // Import the provider

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<Cart> fetchCart(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/keranjang/json/');
    return Cart.fromJson(response);
  }

  Future<void> updateQuantity(
      CookieRequest request, String itemId, int quantity) async {
    try {
      final url = 'http://localhost:8000/keranjang/update-keranjang-ajax/$itemId/';
      final response = await request.post(url, {
        'quantity': quantity.toString(),
      });
      debugPrint('Update Quantity Response: $response'); // Debugging
      if (response['success'] == true) {
        setState(() {}); // Refresh the page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response['message'] ?? 'Gagal memperbarui jumlah')),
        );
      }
    } catch (e) {
      print('Update Quantity Error: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui jumlah')),
      );
    }
  }

  Future<void> removeItem(CookieRequest request, String itemId) async {
    try {
      final url = 'http://localhost:8000/keranjang/hapus-dari-keranjang-ajax/$itemId/';
      final response = await request.post(url, {});
      print('Remove Item Response: $response'); // Debugging
      if (response['success'] == true) {
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response['message'] ?? 'Gagal menghapus item')),
        );
      }
    } catch (e) {
      print('Remove Item Error: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja',
        style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 20)
        ), 
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
      ),
      body: FutureBuilder<Cart>(
        future: fetchCart(request),
        builder: (context, AsyncSnapshot<Cart> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }

          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return _buildEmptyCart();
          }

          return _buildCartContent(snapshot.data!, request);
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Keranjang belanja Anda kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to main (BottomNavbar)
                Navigator.pushReplacementNamed(context, '/main');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF03D9FF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.shopping_bag, color: Colors.white),
              label: const Text(
                'Lanjut Belanja',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(Cart cart, CookieRequest request) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CartItemForm(
                    item: item,
                    request: request,
                    onUpdateQuantity: (id, qty) => updateQuantity(request, id, qty),
                    onRemoveItem: (id) => removeItem(request, id),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(cart.total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03D9FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<NavigationProvider>(context, listen: false).setIndex(2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03D9FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Beli Sekarang!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
