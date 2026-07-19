import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  // Cek apakah user sudah login sebelumnya (Auto-login)
  Future<bool> tryAutoLogin() async {
    final token = await ApiService.getToken();
    if (token == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.fetchProfile();
      if (response['success'] == true && response['data'] != null) {
        _currentUser = UserModel.fromJson(response['data']);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = 'Auto login gagal: $e';
    }

    // Jika gagal fetch profile, kemungkinan token expired
    await ApiService.deleteToken();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Fungsi Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      
      if (response['success'] == true) {
        final userData = response['data'] ?? response['user'];
        if (userData != null) {
          _currentUser = UserModel.fromJson(userData);
        } else {
          // Fallback jika kembalian user di root
          _currentUser = UserModel.fromJson(response);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Email atau password salah.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Fungsi Register
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.register(name, email, password);
      
      if (response['success'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal mendaftarkan akun.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Ambil profil terbaru
  Future<void> fetchProfile() async {
    try {
      final response = await ApiService.fetchProfile();
      if (response['success'] == true && response['data'] != null) {
        _currentUser = UserModel.fromJson(response['data']);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat profil: $e';
    }
  }

  // Perbarui profil
  Future<bool> updateProfile(String name, String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.updateProfile(name, email);
      if (response['success'] == true) {
        // Refresh profil
        await fetchProfile();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memperbarui profil.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Fungsi Logout
  Future<void> logout() async {
    await ApiService.deleteToken();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
