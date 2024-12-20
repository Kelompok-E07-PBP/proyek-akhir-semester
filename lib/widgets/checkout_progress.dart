import 'package:flutter/material.dart';

class CheckoutProgress extends StatelessWidget {
  final int currentStep; // 0-based: 0=Cart, 1=Address, 2=Payment

  CheckoutProgress({super.key, required this.currentStep});

  final List<String> steps = ['Cart', 'Address', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding to avoid clipping
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 14, // Align the connector line to the center of the circles
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildConnectors(context),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildSteps(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSteps(BuildContext context) {
    return List.generate(steps.length, (index) {
      bool isCompleted = index < currentStep;
      bool isActive = index == currentStep;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepIcon(context, isCompleted, isActive, index + 1),
          const SizedBox(height: 8),
          Text(
            steps[index],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive || isCompleted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ],
      );
    });
  }

  List<Widget> _buildConnectors(BuildContext context) {
    return List.generate(
      steps.length - 1,
      (index) => Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 14), // Ensure the line stops before the circle
          color: index < currentStep
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildStepIcon(
      BuildContext context, bool isCompleted, bool isActive, int stepNumber) {
    if (isCompleted) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 18),
      );
    } else if (isActive) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$stepNumber',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$stepNumber',
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}
