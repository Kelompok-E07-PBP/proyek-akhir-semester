import 'dart:convert';

List<Pengiriman> pengirimanFromJson(String str) => List<Pengiriman>.from(json.decode(str).map((x) => Pengiriman.fromJson(x)));

String pengirimanToJson(List<Pengiriman> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pengiriman {
    String model;
    int pk;
    Fields fields;

    Pengiriman({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Pengiriman.fromJson(Map<String, dynamic> json) => Pengiriman(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    DateTime createdAt;
    String firstName;
    String lastName;
    String email;
    int phoneNumber;
    String address;
    String city;
    int postalCode;
    String courier;

    Fields({
        required this.user,
        required this.createdAt,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.phoneNumber,
        required this.address,
        required this.city,
        required this.postalCode,
        required this.courier,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        createdAt: DateTime.parse(json["created_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        city: json["city"],
        postalCode: json["postal_code"],
        courier: json["courier"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "created_at": createdAt.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "address": address,
        "city": city,
        "postal_code": postalCode,
        "courier": courier,
    };
}
