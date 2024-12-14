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
}
