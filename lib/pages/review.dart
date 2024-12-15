import 'package:flutter/material.dart';
import 'package:mujur_reborn/pages/review_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ulasan'),
      ),
      body: const Center(
        child: Text(
          'Belum ada Ulasan di Mujur Reborn.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0, // Adjust font size as needed
            fontWeight: FontWeight.normal, // Optional styling
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReviewEntryFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


// class ReviewPage extends StatelessWidget {
//   final List<Map<String, dynamic>> reviews;

//   const ReviewPage({super.key, required this.reviews});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Daftar Ulasan'),
//       ),
//       body: (reviews.isNotEmpty && _isValidReviewList(reviews))
//           ? ListView.builder(
//               padding: const EdgeInsets.all(8.0),
//               itemCount: reviews.length,
//               itemBuilder: (context, index) {
//                 final review = reviews[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           review['nama_produk'] ?? 'Nama tidak tersedia',
//                           style: const TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8.0),
//                         Text('Komentar: ${review['komentar'] ?? 'Tidak ada komentar'}'),
//                         const SizedBox(height: 4.0),
//                         Text('Rating: ${review['rating'] ?? 'Tidak ada rating'}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//           : const Center(
//               child: Text(
//                 'Belum ada ulasan atau format ulasan tidak valid.',
//                 style: TextStyle(fontSize: 18.0),
//               ),
//             ),
//     );
//   }

//   bool _isValidReviewList(List<Map<String, dynamic>> reviews) {
//     return reviews.every((review) {
//       return review.containsKey('nama_produk') &&
//           review.containsKey('komentar') &&
//           review.containsKey('rating');
//     });
//   }
// }
