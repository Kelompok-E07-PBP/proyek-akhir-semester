import 'package:flutter/material.dart';
import 'package:mujur_reborn/admin_widgets/product_card_admin.dart';
import 'package:mujur_reborn/models/product.dart';
import 'package:mujur_reborn/widgets/filter_button.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage>{
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

          //TODO: Implement filtering logic!
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
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.75, 
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_ , index) {
                        return ProductCardAdmin(
                          imageUrl: snapshot.data![index].fields.gambarProduk,
                          productName: snapshot.data![index].fields.namaProduk,
                          category: snapshot.data![index].fields.kategori,
                          price: double.parse(snapshot.data![index].fields.harga),
                          onEdit: () {
                            // Add your edit functionality here
                            print('Edit product: ${snapshot.data![index].fields.namaProduk}');
                          },
                          onDelete: () {
                            // Add your delete functionality here
                            print('Delete product: ${snapshot.data![index].fields.namaProduk}');
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