import 'package:flutter/material.dart';
import 'package:mujur_reborn/pages/review.dart';

class UlasanEntryFormPage extends StatefulWidget {
  const UlasanEntryFormPage({Key? key}) : super(key: key);

  @override
  State<UlasanEntryFormPage> createState() => _UlasanEntryFormPageState();
}

class _UlasanEntryFormPageState extends State<UlasanEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _reviews = [];

  String _namaProduk = '';
  String _komentar = '';
  double? _rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Tambah Ulasan Produk'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Nama Produk', 'Masukkan nama produk', (value) => _namaProduk = value),
              const SizedBox(height: 16.0),
              _buildTextField('Komentar', 'Masukkan komentar', (value) => _komentar = value, maxLines: 3),
              const SizedBox(height: 16.0),
              _buildRatingField(),
              const SizedBox(height: 24.0),
              _buildSaveButton(),
              const SizedBox(height: 16.0),
              _buildReviewPageButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged, {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      maxLines: maxLines,
      onChanged: onChanged,
      validator: (value) => value!.isEmpty ? '$label tidak boleh kosong!' : null,
    );
  }

  Widget _buildRatingField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Rating',
        hintText: 'Masukkan rating (1.0 - 5.0)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) => _rating = double.tryParse(value),
      validator: (value) {
        final ratingValue = double.tryParse(value ?? '');
        return (ratingValue == null || ratingValue < 1.0 || ratingValue > 5.0) 
            ? 'Rating harus antara 1.0 hingga 5.0' 
            : null;
      },
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveReview,
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      child: const Text('Simpan Ulasan'),
    );
  }

  Widget _buildReviewPageButton() {
    return ElevatedButton(
      onPressed: _navigateToReviewPage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade700,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('Lihat Ulasan'),
    );
  }

  void _saveReview() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _reviews.add({
          'nama_produk': _namaProduk,
          'komentar': _komentar,
          'rating': _rating,
        });
      });
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ulasan Berhasil Disimpan!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Produk: $_namaProduk'),
            Text('Komentar: $_komentar'),
            Text('Rating: $_rating'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _formKey.currentState!.reset();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToReviewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewPage(reviews: _reviews)),
    );
  }
}
