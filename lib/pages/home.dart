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

class _HomePageState extends State<HomePage> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  bool dataLoaded = false; // <-- Add a flag to indicate data initialization

  late Future<List<Product>> productFuture;

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    productFuture = fetchProduct(request); // load data once
  }

  Future<List<Product>> fetchProduct(CookieRequest request) async {
    final response = await request.get('https://valentino-vieri-mujurreborn.pbp.cs.ui.ac.id/json/');
    var data = response;

    List<Product> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct;
  }

  void filterByCategory(String category) {
    setState(() {
      filteredProducts = allProducts
          .where((product) => product.fields.kategori == category)
          .toList();
    });
  }

  Future<void> addToCart(CookieRequest request, Product product, int quantity) async {
    final url = 'https://valentino-vieri-mujurreborn.pbp.cs.ui.ac.id/keranjang/tambah-ke-keranjang-ajax/${product.pk}/';
    final response = await request.post(url, {
      'quantity': quantity.toString(),
    });

    if (response != null && response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Berhasil menambahkan ke keranjang!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response?['message'] ?? 'Gagal menambahkan ke keranjang.')),
      );
    }
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
                        filteredProducts = List.from(allProducts);
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
            future: productFuture,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data produk pada Mujur Reborn.'),
                  );
                } else {
                  // Only initialize once
                  if (!dataLoaded) {
                    allProducts = snapshot.data;
                    filteredProducts = List.from(allProducts);
                    dataLoaded = true;
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
                          onAddToCart: (int quantity) {
                            addToCart(request, filteredProducts[index], quantity);
                          },
                        );
                      },
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
