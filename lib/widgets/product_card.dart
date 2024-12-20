import 'package:flutter/material.dart';
import 'package:mujur_reborn/widgets/button.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String category;
  final double price;
  final void Function(int quantity)? onAddToCart;

  const ProductCard({
    required this.imageUrl,
    required this.productName,
    required this.category,
    required this.price,
    this.onAddToCart,
    super.key,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 0;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
            ),
          ),

          // Bottom section with a subtle background color and padding
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // A subtle divider
                  Divider(color: Colors.grey.shade300, thickness: 1),

                  const SizedBox(height: 4),

                  // Category
                  Text(
                    widget.category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    'Rp ${widget.price.toStringAsFixed(3)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Quantity selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.black87),
                        onPressed: _decrement,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black87),
                        onPressed: _increment,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Add to Cart button
                  // Add to Cart button using CustomButton
                  CustomButton(
                    text: 'Add to Cart',
                    icon: Icons.shopping_cart_outlined,
                    onPressed: () {
                      if (_quantity > 0) {
                        widget.onAddToCart?.call(_quantity);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pilih jumlah yang lebih dari 0 sebelum menambahkan ke keranjang.'),
                          ),
                        );
                      }
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal, // Not bold
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
