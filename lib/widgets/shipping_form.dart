import 'package:flutter/material.dart';

class ShippingForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const ShippingForm({super.key, required this.onSubmit});

  @override
  _ShippingFormState createState() => _ShippingFormState();
}

class _ShippingFormState extends State<ShippingForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'phone_number': '',
    'address': '',
    'city': '',
    'postal_code': '',
    'courier': '',
  };

  // Dropdown options
  final List<String> _cities = [
    'Jakarta Barat',
    'Jakarta Pusat',
    'Jakarta Selatan',
    'Jakarta Timur',
    'Jakarta Utara',
  ];

  final List<String> _couriers = [
    'JNE',
    'SiCepat',
    'Gojek',
    'Grab',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [            
            // First Name
            _buildTextField('Nama Depan', 'first_name'),
            const SizedBox(height: 16),

            // Last Name
            _buildTextField('Nama Belakang', 'last_name'),
            const SizedBox(height: 16),

            // Email
            _buildTextField('Email', 'email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),

            // Address
            _buildTextField('Alamat', 'address', maxLines: 3),
            const SizedBox(height: 16),

            // City (Dropdown)
            _buildDropdownField('Kota', 'city', _cities),
            const SizedBox(height: 16),

            // Postal Code
            _buildTextField('Kode Pos', 'postal_code', keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            // Courier (Dropdown)
            _buildDropdownField('Kurir', 'courier', _couriers),
            const SizedBox(height: 16),

            // Phone Number (with country code prefix)
            _buildPhoneNumberField(),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lanjut Pembayaran',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String field, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) => (value == null || value.isEmpty) ? 'Field ini diperlukan' : null,
      onSaved: (value) => _formData[field] = value?.trim() ?? '',
    );
  }

  Widget _buildDropdownField(String label, String field, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
      validator: (value) => (value == null || value.isEmpty) ? 'Field ini diperlukan' : null,
      onChanged: (value) => _formData[field] = value ?? '',
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
          ),
          child: const Text('+62', style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nomor Telepon',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => (value == null || value.isEmpty) ? 'Field ini diperlukan' : null,
            onSaved: (value) => _formData['phone_number'] = value?.trim() ?? '',
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      widget.onSubmit(_formData);
    }
  }
}
