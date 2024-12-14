import 'package:flutter/material.dart';
import 'package:mujur_reborn/widgets/filter_button.dart';
import 'package:mujur_reborn/widgets/product_card.dart';
import 'package:mujur_reborn/widgets/sliding_banner.dart'; 
import 'package:mujur_reborn/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  Future<List<Product>> fetchProduct(CookieRequest request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://localhost:8000/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object Product
    List<Product> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct;
  }

  //Fungsi ini akan memilih produk yang esuai dengan kategori tertentu.
  void filterByCategory(String category) {
    setState(() {
      filteredProducts = allProducts
          .where((product) => product.fields.kategori == category)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
                    onPressed: () {
                      setState(() {
                        filteredProducts = allProducts;
                      });
                    },
                  ),
                  FilterButton(
                    label: 'Dasi Instant',
                    onPressed: () {
                      filterByCategory('Dasi Instant');
                    },
                  ),
                  FilterButton(
                    label: 'Dasi Manual',
                    onPressed: () {
                      filterByCategory('Dasi Manual');
                    },
                  ),
                  FilterButton(
                    label: 'Dasi Kupu-Kupu',
                    onPressed: () {
                      filterByCategory('Dasi Kupu-Kupu');
                    },
                  ),
                  FilterButton(
                    label: 'Jepitan Dasi',
                    onPressed: () {
                      filterByCategory('Jepitan Dasi');
                    },
                  ),
                ],
              ),
            ),
          ),
          
          FutureBuilder(
            future: fetchProduct(request),
            builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
                if (!snapshot.hasData) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum ada data produk pada Mujur Reborn.',
                        style: TextStyle(fontSize: 20, color: Color(0xFF00ACED)),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {

                  //Atur nilai default untuk allProducts dan filteredProducts.
                  allProducts = snapshot.data;
                  if (filteredProducts.isEmpty) {
                    filteredProducts = allProducts;
                  }

                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.75, 
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (_ , index) {
                        return ProductCard(
                          imageUrl: filteredProducts[index].fields.gambarProduk,
                          productName: filteredProducts[index].fields.namaProduk,
                          category: filteredProducts[index].fields.kategori,
                          price: double.parse(filteredProducts[index].fields.harga),
                        );
                      },
                    ),
                  );
                }
              }
            }
          ),
        ],
      ),
    );
  }
}