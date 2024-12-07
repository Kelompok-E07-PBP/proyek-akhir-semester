import 'package:flutter/material.dart';
import 'package:mujur_reborn/admin_widgets/product_card_admin.dart';

class HomeAdminPage extends StatelessWidget {
  HomeAdminPage({super.key});

  final List<Map<String, dynamic>> products = [
    {
      'image': 'assets/images/banner1.png',
      'name': 'Product 1',
      'price': 72.000,
    },
    {
      'image': 'assets/images/banner1.png',
      'name': 'Product 2',
      'price': 30.000,
    },
    {
      'image': 'assets/images/banner1.png',
      'name': 'Product 3',
      'price': 30.000,
    },
    {
      'image': 'assets/images/banner1.png',
      'name': 'Product 4',
      'price': 200.000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // You can reuse the SlidingBanner if you wish
          // or create a new admin-specific banner.
          // For example:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Admin Dashboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75, 
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCardAdmin(
                  imageUrl: products[index]['image'],
                  productName: products[index]['name'],
                  price: products[index]['price'],
                  onEdit: () {
                    // Add your edit functionality here
                    print('Edit product: ${products[index]['name']}');
                  },
                  onDelete: () {
                    // Add your delete functionality here
                    print('Delete product: ${products[index]['name']}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
