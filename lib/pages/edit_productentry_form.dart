import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mujur_reborn/models/product.dart';

class EditProductEntryFormPage extends StatefulWidget {
  //Deklarasikan produk dan fungsi untuk produk sehingga form bisa mengakses dua hal tersebut.
  final Product product;
  final Function(Product) updateProduct;

  const EditProductEntryFormPage({super.key, required this.product, required this.updateProduct});

  @override
  State<EditProductEntryFormPage> createState() => _EditProductEntryFormPageState();
}

class _EditProductEntryFormPageState extends State<EditProductEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaProdukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _gambarProdukController = TextEditingController();

  String _namaProduk = "";
  String _kategori = "";
  int _harga = 0;
  String _gambarProduk = "";
  final List<Map<String, String>> _kategoriProduk = [
    {'value': 'Dasi Instant', 'label': 'Dasi Instant'},
    {'value': 'Dasi Manual', 'label': 'Dasi Manual'},
    {'value': 'Dasi Kupu-Kupu', 'label': 'Dasi Kupu-Kupu'},
    {'value': 'Jepitan Dasi', 'label': 'Jepitan Dasi'},
  ];

  @override
  void initState() {
    super.initState();
    
     // Atur nilai initial form sesuai dengan data produk sebelum diedit.
    _namaProdukController.text = widget.product.fields.namaProduk;
    _hargaController.text = widget.product.fields.harga;
    _gambarProdukController.text = widget.product.fields.gambarProduk;
    _kategori = widget.product.fields.kategori;

    _namaProduk = _namaProdukController.text;
    _harga = double.tryParse(_hargaController.text)?.toInt() ?? 0;
    _gambarProduk = _gambarProdukController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Edit Produk',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key:_formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Bagian untuk mengatur input nama produk
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _namaProdukController,
                  decoration: InputDecoration(
                    hintText: "Nama Produk",
                    labelText: "Nama Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _namaProduk = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama Produk tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              //Bagian untuk mengatur dropdown menu.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _kategori, 
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: _kategoriProduk.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['value'],
                      child: Text(category['label']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _kategori = newValue!; 
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Silahkan pilih sebuah kategori!';
                    }
                    return null;
                  },
                ),
              ),

              //Bagian untuk mengatur input harga produk.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _hargaController,
                  decoration: InputDecoration(
                    hintText: "Harga Produk",
                    labelText: "Harga Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number, // Pastikan keyboard numeric yang keluar.
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+')), // Hanya boleh bilangan bulat.
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _harga = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Harga produk tidak boleh kosong!";
                    }

                    // Periksa apakah nilai yang dimasukkan valid.
                    final parsedValue = num.tryParse(value);
                    if (parsedValue == null) {
                      return "Harga produk harus berupa angka!";
                    }

                    // Periksa apakah nilai yang dimasukkan adalah bilangan bulat atau tidak.
                    if (parsedValue is double && parsedValue % 1 != 0) {
                      return "Harga produk harus bilangan bulat!";
                    }

                    // Patikan harga positif.
                    if (parsedValue <= 0) {
                      return "Harga produk harus lebih dari 0!";
                    }

                    return null;
                  },
                ),
              ),

              //Bagian untuk mengatur input url gambar produk.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _gambarProdukController,
                  decoration: InputDecoration(
                    hintText: "Link Gambar Produk",
                    labelText: "Gambar Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _gambarProduk = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Link Gambar Produk tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              //Bagian untuk mengatur tombol submit
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),

                    // TODO: Modify this part to work the update!
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                      
                        // Simpan data dari form.
                        _formKey.currentState!.save();

                        // Buat suatu objek Fields dengan data baru.
                        Fields updatedFields = widget.product.fields.copyWith(
                          namaProduk: _namaProduk,       
                          kategori: _kategori,           
                          harga: _harga.toString(),      
                          gambarProduk: _gambarProduk,   
                        );

                        // Buat objek Product baru dengan nilai baru dari fields.
                        Product updatedProduct = widget.product.copyWith(
                          fields: updatedFields,
                        );

                        // Panggil fungsi updateProduct dengan data baru.
                        await widget.updateProduct(updatedProduct);

                        // Navigasi kembali ke halaman admin setelah update.
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}