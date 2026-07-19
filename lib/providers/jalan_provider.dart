import 'package:flutter/material.dart';
import '../models/jalan_model.dart';
import '../services/api_service.dart';

class JalanProvider with ChangeNotifier {
  List<JalanModel> _jalans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<JalanModel> get jalans => _jalans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mengambil daftar jalan tol dari server
  Future<void> fetchJalanList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.fetchJalan();
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> listData = response['data'];
        _jalans = listData.map((json) => JalanModel.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat daftar jalan tol.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
