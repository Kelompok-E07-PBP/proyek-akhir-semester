import 'package:flutter/material.dart';

class PaymentMethodForm extends StatelessWidget {
  final String? selectedPaymentMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodForm({
    Key? key,
    required this.selectedPaymentMethod,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildRadioOption('Kartu Kredit'),
        const SizedBox(height: 16), 
        _buildRadioOption('Kartu Debit'),
        const SizedBox(height: 16),
        _buildRadioOption('Transfer Bank'),
        const SizedBox(height: 16),
        _buildRadioOption('E-Wallet'),
      ],
    );
  }

  Widget _buildRadioOption(String method) {
    return Center(
      child: SizedBox(
        width: 300,
        child: RadioListTile<String>(
          title: Center(child: Text(method)),
          value: method,
          groupValue: selectedPaymentMethod,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
