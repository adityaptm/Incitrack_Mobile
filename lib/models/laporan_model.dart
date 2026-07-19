import 'user_model.dart';
import 'jalan_model.dart';

class LaporanModel {
  final int id;
  final int userId;
  final int jalanId;
  final String jenis;
  final String lokasi;
  final double latitude;
  final double longitude;
  final String? penyebab;
  final String? dampak;
  final String? foto;
  final String? video;
  final String status;
  final String createdAt;
  final UserModel? user;
  final JalanModel? jalan;

  LaporanModel({
    required this.id,
    required this.userId,
    required this.jalanId,
    required this.jenis,
    required this.lokasi,
    required this.latitude,
    required this.longitude,
    this.penyebab,
    this.dampak,
    this.foto,
    this.video,
    required this.status,
    required this.createdAt,
    this.user,
    this.jalan,
  });

  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    // Parser koordinat ke double dengan aman
    double parseCoordinate(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return LaporanModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      jalanId: json['jalan_id'] ?? 0,
      jenis: json['jenis_kecelakaan'] ?? json['jenis'] ?? '',
      lokasi: json['lokasi'] ?? '',
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
      penyebab: json['penyebab'],
      dampak: json['dampak'],
      foto: json['foto_bukti'] ?? json['foto'],
      video: json['video_bukti'] ?? json['video'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      jalan: json['jalan'] != null ? JalanModel.fromJson(json['jalan']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'jalan_id': jalanId,
      'jenis': jenis,
      'lokasi': lokasi,
      'latitude': latitude,
      'longitude': longitude,
      'penyebab': penyebab,
      'dampak': dampak,
      'foto': foto,
      'video': video,
      'status': status,
      'created_at': createdAt,
    };
  }
}
