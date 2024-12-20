import 'package:flutter/material.dart';
import 'package:mujur_reborn/providers/navigation_provider.dart';
import 'package:mujur_reborn/widgets/button.dart';
import 'package:provider/provider.dart';

class EmptyShipping extends StatelessWidget {
  final String message;

  const EmptyShipping({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Lengkapi Data Pengiriman',
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false).setIndex(2);
              },
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
