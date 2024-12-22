import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mujur_reborn/models/cart_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CartItemForm extends StatelessWidget {
  final CartItem item;
  final CookieRequest request;
  final Function(String, int) onUpdateQuantity;
  final Function(String) onRemoveItem;

  const CartItemForm({
    super.key,
    required this.item,
    required this.request,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shopping_bag,  // Or any other icon you prefer
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Product details
            Expanded(
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
                  Text(
                    currencyFormatter.format(item.price),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (item.quantity > 1) {
                            onUpdateQuantity(item.id, item.quantity - 1);
                          }
                        },
                        icon:  Icon(Icons.remove_circle_outline, color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          onUpdateQuantity(item.id, item.quantity + 1);
                        },
                        icon:  Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => onRemoveItem(item.id),
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
