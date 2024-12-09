import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CartItem {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;

  CartItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }
}

class Cart {
  final String username;
  final String cartId;
  final double total;
  final List<CartItem> items;
  final String createdAt;
  final String updatedAt;

  Cart({
    required this.username,
    required this.cartId,
    required this.total,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<CartItem> cartItems = itemsList.map((item) => CartItem.fromJson(item)).toList();

    return Cart(
      username: json['username'],
      cartId: json['cart_id'],
      total: json['total'].toDouble(),
      items: cartItems,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<Cart> fetchCart(CookieRequest request) async {
    final response = await request.get(
      // 'https://valentino-vieri-mujurreborn.pbp.cs.ui.ac.id/keranjang/json/',
      'http://localhost:8000/keranjang/json/',
    );
    return Cart.fromJson(response);
  }

  Future<void> updateQuantity(CookieRequest request, String itemId, int quantity) async {
    try {
      await request.post(
        // 'https://valentino-vieri-mujurreborn.pbp.cs.ui.ac.id/keranjang/update-ajax/$itemId/',
        'http:localhost:8000/keranjang/update-ajax/$itemId/',
        {'quantity': quantity.toString()},
      );
      setState(() {}); // Refresh the page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui jumlah')),
      );
    }
  }

  Future<void> removeItem(CookieRequest request, String itemId) async {
    try {
      await request.post(
        // 'https://valentino-vieri-mujurreborn.pbp.cs.ui.ac.id/keranjang/hapus-ajax/$itemId/',
        'http://localhost:8000/keranjang/hapus-ajax/$itemId/',
        {},
      );
      setState(() {}); // Refresh the page
    } catch (e) {
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
        title: const Text('Keranjang Belanja'),
        centerTitle: true,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80),
          const SizedBox(height: 16),
          const Text(
            'Keranjang belanja Anda kosong',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF03D9FF),
            ),
            child: const Text('Lanjut Belanja!'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(Cart cart, CookieRequest request) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(item.price),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => updateQuantity(
                                  request,
                                  item.id,
                                  item.quantity - 1,
                                ),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => updateQuantity(
                                  request,
                                  item.id,
                                  item.quantity + 1,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => removeItem(request, item.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text(
                            NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(item.subtotal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
              ),
            ],
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(cart.total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to checkout
                      Navigator.pushNamed(context, '/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03D9FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Beli Sekarang!',
                      style: TextStyle(fontSize: 16),
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