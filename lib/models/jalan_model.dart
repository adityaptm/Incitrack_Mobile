class JalanModel {
  final int id;
  final String namaJalan;

  JalanModel({
    required this.id,
    required this.namaJalan,
  });

  factory JalanModel.fromJson(Map<String, dynamic> json) {
    return JalanModel(
      id: json['id'] ?? 0,
      namaJalan: json['nama_jalan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_jalan': namaJalan,
    };
  }
}
