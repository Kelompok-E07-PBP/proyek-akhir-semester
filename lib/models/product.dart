// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String model;
    String pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };

    // Method copyWith untuk Product untuk salin data dari produk.
    Product copyWith({
      String? model,
      String? pk,
      Fields? fields,
    }) {
      return Product(
        model: model ?? this.model,
        pk: pk ?? this.pk,
        fields: fields ?? this.fields,
      );
    }
}

class Fields {
    String namaProduk;
    String kategori;
    String harga;
    String gambarProduk;

    Fields({
        required this.namaProduk,
        required this.kategori,
        required this.harga,
        required this.gambarProduk,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaProduk: json["nama_produk"],
        kategori: json["kategori"],
        harga: json["harga"],
        gambarProduk: json["gambar_produk"],
    );

    Map<String, dynamic> toJson() => {
        "nama_produk": namaProduk,
        "kategori": kategori,
        "harga": harga,
        "gambar_produk": gambarProduk,
    };

    // Method copyWith pada fields untuk salin atribut pada fields.
    Fields copyWith({
      String? namaProduk,
      String? kategori,
      String? harga,
      String? gambarProduk,
    }) {
      return Fields(
        namaProduk: namaProduk ?? this.namaProduk,
        kategori: kategori ?? this.kategori,
        harga: harga ?? this.harga,
        gambarProduk: gambarProduk ?? this.gambarProduk,
      );
    }
}
