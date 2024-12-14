class Payment {
  final int id;
  final String user;
  final double amount;
  final String paymentMethod;
  final String createdAt;
  final String updatedAt;

  Payment({
    required this.id,
    required this.user,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['pk'],
      user: json['fields']['user'],
      amount: double.parse(json['fields']['amount']),
      paymentMethod: json['fields']['payment_method'],
      createdAt: json['fields']['created_at'],
      updatedAt: json['fields']['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'amount': amount.toString(),
        'payment_method': paymentMethod,
      };
}
