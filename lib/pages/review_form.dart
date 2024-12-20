import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewFormPage extends StatefulWidget {
  final Map<String, dynamic>? reviewData;
  final bool isEditing;

  const ReviewFormPage({super.key, this.reviewData, required this.isEditing});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _namaProduk = '';
  String _komentar = '';
  int? _rating;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.reviewData != null) {
      _namaProduk = widget.reviewData!['nama_produk_ulas'] ?? '';
      _komentar = widget.reviewData!['komentar'] ?? '';
      _rating = widget.reviewData!['rating'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Ulasan Produk' : 'Tambah Ulasan Produk'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged, {int maxLines = 1}) {
    return TextFormField(
      initialValue: widget.isEditing ? (label == 'Nama Produk' ? _namaProduk : _komentar) : '',
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
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Rating',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      value: _rating,
      items: [1, 2, 3, 4, 5].map((int value) {
        return DropdownMenuItem(value: value, child: Text(value.toString()));
      }).toList(),
      onChanged: (value) => setState(() => _rating = value),
      validator: (value) {
        if (value == null) return 'Pilih rating dari 1 hingga 5';
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveReview,
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      child: Text(widget.isEditing ? 'Simpan Perubahan' : 'Simpan Ulasan'),
    );
  }

  void _saveReview() async {
    if (_formKey.currentState!.validate()) {
      final reviewData = {
        'nama_produk_ulas': _namaProduk,
        'komentar': _komentar,
        'rating': _rating.toString(),
      };

    try {
      final url = widget.isEditing
          ? Uri.parse('http://localhost:8000/ulasan/edit-ulasan-ajax/${widget.reviewData!['id']}/').toString()
          : Uri.parse('http://localhost:8000/ulasan/create-ulasan-entry-ajax/').toString();

      final response = await CookieRequest().post(url, reviewData);
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
    }

    }
  }
}
