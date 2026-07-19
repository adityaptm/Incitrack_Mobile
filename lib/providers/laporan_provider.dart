import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/laporan_model.dart';
import '../services/api_service.dart';

class LaporanProvider with ChangeNotifier {
  List<LaporanModel> _laporans = [];
  List<LaporanModel> _userLaporans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<LaporanModel> get laporans => _laporans;
  List<LaporanModel> get userLaporans => _userLaporans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch semua laporan tervalidasi untuk peta utama
  Future<void> fetchAllLaporans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.fetchLaporan();
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> listData = response['data'];
        _laporans = listData.map((json) => LaporanModel.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat laporan kecelakaan.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch riwayat laporan khusus user yang sedang login
  Future<void> fetchUserLaporans(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Kita fetch semua laporan lalu filter berdasarkan userId 
      // (atau jika backend punya endpoint khusus, bisa diganti ke endpoint tersebut)
      final response = await ApiService.fetchLaporan();
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> listData = response['data'];
        final all = listData.map((json) => LaporanModel.fromJson(json)).toList();
        
        // Filter laporan milik user bersangkutan (baik valid, pending, maupun invalid jika API mengembalikan semuanya)
        // Di Laravel, index LaporanApiController mengembalikan yang status valid saja. 
        // Tetapi untuk menu "Riwayat Saya", biasanya butuh laporan pending/invalid juga.
        // Kita filter yang user_id cocok.
        _userLaporans = all.where((lap) => lap.userId == userId).toList();
        _errorMessage = null;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat riwayat laporan Anda.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fungsi Kirim Laporan Baru
  Future<bool> kirimLaporan({
    required int jalanId,
    required String jenisKecelakaan,
    required String lokasi,
    required double latitude,
    required double longitude,
    String? penyebab,
    String? dampak,
    XFile? fotoFile,
    XFile? videoFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final Map<String, String> fields = {
        'jalan_id': jalanId.toString(),
        'jenis': jenisKecelakaan,
        'lokasi': lokasi,
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'tanggal': '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'waktu': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      };

      if (penyebab != null && penyebab.isNotEmpty) {
        fields['penyebab'] = penyebab;
      }
      if (dampak != null && dampak.isNotEmpty) {
        fields['dampak'] = dampak;
      }

      final response = await ApiService.kirimLaporan(fields, fotoFile, videoFile);
      
      if (response['success'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal mengirimkan laporan.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan pengunggahan: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
