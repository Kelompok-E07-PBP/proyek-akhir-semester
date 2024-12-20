import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mujur_reborn/models/review_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewItem extends StatelessWidget {
  final UlasanEntry review;
  final Function(String) onRemoveReview;
  final Function(UlasanEntry) onEditReview;

  const ReviewItem({
    super.key,
    required this.review,
    required this.onRemoveReview,
    required this.onEditReview, required String formattedDate, required CookieRequest request,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat.yMMMd('id_ID').add_jm();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateFormatter.format(review.waktu),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Produk: ${review.namaProdukUlas}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(review.komentar),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEditReview(review),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onRemoveReview(review.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
