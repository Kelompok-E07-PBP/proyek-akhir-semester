class UlasanEntry {
  final String id;
  final String username;
  final DateTime waktu;
  final String namaProdukUlas;
  final int rating;
  final String komentar;

  UlasanEntry({
    required this.id,
    required this.username,
    required this.waktu,
    required this.namaProdukUlas,
    required this.rating,
    required this.komentar,
  });

  factory UlasanEntry.fromJson(Map<String, dynamic> json) {
    return UlasanEntry(
      id: json['id'],
      username: json['username'],
      waktu: DateTime.parse(json['waktu']),
      namaProdukUlas: json['nama_produk_ulas'],
      rating: json['rating'],
      komentar: json['komentar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_produk_ulas': namaProdukUlas,
      'rating': rating,
      'komentar': komentar,
    };
  }
}
