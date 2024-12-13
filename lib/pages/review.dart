import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  
  const ReviewPage({required this.reviews, Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Ulasan'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: (reviews.isNotEmpty && _isValidReviewList(reviews))
          ? ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['nama_produk'] ?? 'Nama tidak tersedia',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text('Komentar: ${review['komentar'] ?? 'Tidak ada komentar'}'),
                        const SizedBox(height: 4.0),
                        Text('Rating: ${review['rating'] ?? 'Tidak ada rating'}'),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'Belum ada ulasan atau format ulasan tidak valid.',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
    );
  }

  bool _isValidReviewList(List<Map<String, dynamic>> reviews) {
    return reviews.every((review) {
      return review.containsKey('nama_produk') &&
          review.containsKey('komentar') &&
          review.containsKey('rating');
    });
  }
}
