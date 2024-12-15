import 'package:flutter/material.dart';
import 'package:mujur_reborn/admin_widgets/product_card_admin.dart';
import 'package:mujur_reborn/models/product.dart';
import 'package:mujur_reborn/widgets/filter_button.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage>{
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  //Fungsi untuk mengatur logika fetch product dari Django
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

  //Fungsi untuk mengatur logika delete product dari Flutter ke Django.
  Future<void> deleteProduct(String id, BuildContext context) async {
    final url = Uri.parse('http://localhost:8000/edit/delete-from-flutter/$id');
    
    try {
      final response = await http.delete(url);

      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil dihapus.'))
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal hapus produk.'))
          );
        }
      }
    } catch (e) {
      // Ensure that the widget is still mounted before using the context
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi masalah saat menghapus produk.'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
                    label: 'Dasi Kupu-kupu',
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
                        return ProductCardAdmin(
                          imageUrl: filteredProducts[index].fields.gambarProduk,
                          productName: filteredProducts[index].fields.namaProduk,
                          category: filteredProducts[index].fields.kategori,
                          price: double.parse(filteredProducts[index].fields.harga),

                          //TODO: Implement Edit Logic!
                          onEdit: () {
                            print('Edit product: ${filteredProducts[index].fields.namaProduk}');
                          },

                          onDelete: () async {
                            await deleteProduct(filteredProducts[index].pk, context);
                            setState(() {
                              allProducts.removeWhere((product) => product.pk == filteredProducts[index].pk);
                              filteredProducts.removeAt(index);
                            });
                          },
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