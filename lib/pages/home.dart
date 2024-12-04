import 'package:flutter/material.dart';
import 'package:mujur_reborn/widgets/filter_button.dart';
import 'package:mujur_reborn/widgets/product_card.dart';
import 'package:mujur_reborn/widgets/sliding_banner.dart'; 

class HomePage extends StatelessWidget {
  HomePage({super.key});

  
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
          const SlidingBanner(
            images: [
              'assets/images/banner1.png',
              'assets/images/banner2.png',
              'assets/images/banner3.png',
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterButton(
                    label: 'Semua',
                    onPressed: () {},
                  ),
                  FilterButton(
                    label: 'Dasi Instan',
                    onPressed: () {},
                  ),
                  FilterButton(
                    label: 'Dasi Manual',
                    onPressed: () {},
                  ),
                  FilterButton(
                    label: 'Dasi Kupu-kupu',
                    onPressed: () {},
                  ),
                  FilterButton(
                    label: 'Jepitan Dasi',
                    onPressed: () {},
                  ),
                ],
              ),
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
                return ProductCard(
                  imageUrl: products[index]['image'],
                  productName: products[index]['name'],
                  price: products[index]['price'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
