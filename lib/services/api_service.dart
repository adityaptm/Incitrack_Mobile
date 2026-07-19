import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  // Gunakan 10.0.2.2 untuk Android Emulator, localhost untuk iOS/Web/Desktop
  static final String baseUrl = kIsWeb
      ? 'http://localhost:8000/api/'
      : (defaultTargetPlatform == TargetPlatform.android ? 'http://10.0.2.2:8000/api/' : 'http://localhost:8000/api/');
      
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Menyimpan token Sanctum
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Membaca token Sanctum
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Menghapus token (Logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Menyiapkan header standar, otomatis menambahkan token jika ada
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Fungsi Login (Tahap 7.1)
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        // Simpan token jika sukses
        if (data['token'] != null) {
          await saveToken(data['token']);
        } else if (data['data'] != null && data['data']['token'] != null) {
          await saveToken(data['data']['token']);
        }
      }
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server: $e',
      };
    }
  }

  // Fungsi Register
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'nama': name, // fallback jika API menggunakan 'nama'
          'email': email,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal mendaftar: $e',
      };
    }
  }

  // Fetch Master Data Jalan Tol
  static Future<Map<String, dynamic>> fetchJalan() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${baseUrl}jalan'),
        headers: headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memuat data jalan: $e',
      };
    }
  }

  // Fetch Laporan Aktif (Valid) untuk Map dan Riwayat
  static Future<Map<String, dynamic>> fetchLaporan() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${baseUrl}laporan'),
        headers: headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memuat data laporan: $e',
      };
    }
  }

  // Kirim Laporan Baru dengan Upload Gambar/Video (Multipart)
  static Future<Map<String, dynamic>> kirimLaporan(
    Map<String, String> fields,
    XFile? fotoFile,
    XFile? videoFile,
  ) async {
    try {
      final uri = Uri.parse('${baseUrl}laporan');
      final request = http.MultipartRequest('POST', uri);
      
      // Ambil headers (khususnya Authorization token)
      final headers = await _getHeaders();
      request.headers.addAll(headers);
      
      // Hapus Content-Type karena multipart membutuhkan boundaries otomatis
      request.headers.remove('Content-Type');

      // Masukkan field teks
      request.fields.addAll(fields);

      // Lampirkan Foto Bukti
      if (fotoFile != null) {
        if (kIsWeb) {
          final bytes = await fotoFile.readAsBytes();
          final multipartFile = http.MultipartFile.fromBytes(
            'foto',
            bytes,
            filename: fotoFile.name,
          );
          request.files.add(multipartFile);
        } else {
          final multipartFile = await http.MultipartFile.fromPath(
            'foto',
            fotoFile.path,
          );
          request.files.add(multipartFile);
        }
      }

      // Lampirkan Video Bukti
      if (videoFile != null) {
        if (kIsWeb) {
          final bytes = await videoFile.readAsBytes();
          final multipartFile = http.MultipartFile.fromBytes(
            'video',
            bytes,
            filename: videoFile.name,
          );
          request.files.add(multipartFile);
        } else {
          final multipartFile = await http.MultipartFile.fromPath(
            'video',
            videoFile.path,
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal mengirim laporan: $e',
      };
    }
  }

  // Get User Profile
  static Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${baseUrl}profile'),
        headers: headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memuat profil: $e',
      };
    }
  }

  // Update User Profile
  static Future<Map<String, dynamic>> updateProfile(String name, String email) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${baseUrl}profile'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memperbarui profil: $e',
      };
    }
  }
}