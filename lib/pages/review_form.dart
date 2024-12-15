import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mujur_reborn/pages/login.dart';
import 'package:mujur_reborn/pages/review.dart';

// TODO: REVIEW = ULASAN!
class ReviewEntryFormPage extends StatefulWidget {
  const ReviewEntryFormPage({super.key});

  @override
  State<ReviewEntryFormPage> createState() => _ReviewEntryFormPageState();
}

class _ReviewEntryFormPageState extends State<ReviewEntryFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _namaProdukUlas = "";
	int _rating = 0;
  String _komentar = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Tambah Ulasan',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      // TODO: Tambahkan drawer yang sudah dibuat di sini
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Bagian input nama produk yang akan diulas.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama produk yang akan diulas",
                    labelText: "Nama Produk Ulas",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _namaProdukUlas = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama produk ulas tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Bagian input rating
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Rating dari 1 sampai 5.",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number, // Pastikan keyboard numeric yang keluar.
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+$')), // Hanya boleh bilangan bulat.
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _rating = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Rating tidak boleh kosong!";
                    }

                    // Periksa apakah nilai yang dimasukkan valid.
                    final parsedValue = num.tryParse(value);
                    if (parsedValue == null) {
                      return "Rating harus berupa angka!";
                    }

                    // Priksa apakah nilainya bilangan bulat atau tidak.
                    if (parsedValue is double && parsedValue % 1 != 0) {
                      return "Rating harus bilangan bulat!";
                    }

                    // Pastikan nilai rating antara 1 sampai 5.
                    if (parsedValue < 1 || parsedValue > 5) {
                      return "Rating harus antara 1-5!";
                    }

                    return null;
                  },
                ),
              ),

              // Bagian input komentar.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Isi komentarmu di sini",
                    labelText: "Komentar",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLines: 5, // Atur jumlah baris kotak komentar di sini
                  onChanged: (String? value) {
                    setState(() {
                      _komentar = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Komentar tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              //Tombol simpan ulasan
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      // ignore: deprecated_member_use
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Mood berhasil tersimpan'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Pengguna: $globalUname'),
                                    const Text('Waktu: waktu sekarang'),
                                    Text('Nama Produk Ulas: $_namaProdukUlas'),
                                    Text('Rating: $_rating'),
                                    Text('Komentar: $_komentar'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
