import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mujur_reborn/models/review_model.dart';
import 'package:mujur_reborn/pages/review_form.dart';
import 'package:mujur_reborn/widgets/review_card.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null); // Inisialisasi locale Indonesia
  }

  Future<List<UlasanEntry>> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get('http://localhost:8000/ulasan/json/'); // Gunakan IP emulator
      print('Response from API: $response');
      return (response as List<dynamic>)
          .map((data) => UlasanEntry.fromJson(data))
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      rethrow;
    }
  }

  Future<void> removeReview(CookieRequest request, String reviewId) async {
    try {
      final url = 'http://localhost:8000/ulasan/delete-ulasan-ajax/$reviewId/';
      final response = await request.post(url, {});
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ulasan berhasil dihapus')),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Gagal menghapus ulasan')),
        );
      }
    } catch (e) {
      print('Error removing review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus ulasan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ulasan Produk',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
      ),
      body: FutureBuilder<List<UlasanEntry>>(
        future: fetchReviews(request),
        builder: (context, AsyncSnapshot<List<UlasanEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}');
            return const Center(child: Text('Terjadi kesalahan saat memuat data.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyReview();
          }

          return _buildReviewContent(snapshot.data!, request);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReviewFormPage(isEditing: false)),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyReview() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined, size: 100, color: Colors.grey),
            SizedBox(height: 24),
            Text(
              'Belum ada ulasan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent(List<UlasanEntry> reviews, CookieRequest request) {
    final dateFormatter = DateFormat.yMMMMd('id_ID'); // Format tanggal lokal
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ReviewItem(
            review: review,
            formattedDate: dateFormatter.format(review.waktu), // Format tanggal
            request: request,
            onRemoveReview: (id) => removeReview(request, id),
            onEditReview: (review) async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(
                    reviewData: review.toJson(),
                    isEditing: true,
                  ),
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
          ),
        );
      },
    );
  }
}
