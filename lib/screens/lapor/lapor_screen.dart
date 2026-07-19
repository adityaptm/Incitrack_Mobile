import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/jalan_provider.dart';
import '../../../providers/laporan_provider.dart';

class LaporScreen extends StatefulWidget {
  const LaporScreen({super.key});

  @override
  State<LaporScreen> createState() => _LaporScreenState();
}

class _LaporScreenState extends State<LaporScreen> {
  final _lokasiController = TextEditingController();
  final _jenisController = TextEditingController();
  final _penyebabController = TextEditingController();
  final _dampakController = TextEditingController();
  
  int? _selectedJalanId;
  double? _latitude;
  double? _longitude;
  bool _isLocating = false;
  String _locationStatus = 'Menunggu deteksi GPS...';

  XFile? _fotoFile;
  XFile? _videoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load list jalan tol dari API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JalanProvider>(context, listen: false).fetchJalanList();
    });
    // Mulai deteksi GPS otomatis
    _determinePosition();
  }

  @override
  void dispose() {
    _lokasiController.dispose();
    _jenisController.dispose();
    _penyebabController.dispose();
    _dampakController.dispose();
    super.dispose();
  }

  // Mendapatkan Posisi GPS Perangkat
  Future<void> _determinePosition() async {
    setState(() {
      _isLocating = true;
      _locationStatus = 'Mendeteksi koordinat GPS...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLocating = false;
          _locationStatus = 'GPS tidak aktif. Aktifkan lokasi Anda.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLocating = false;
            _locationStatus = 'Izin lokasi ditolak.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLocating = false;
          _locationStatus = 'Izin lokasi diblokir permanen.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isLocating = false;
        _locationStatus = 'Lokasi GPS berhasil dikunci otomatis.';
      });
    } catch (e) {
      setState(() {
        _isLocating = false;
        _locationStatus = 'Gagal deteksi GPS: $e';
      });
    }
  }

  // Pilih Foto menggunakan ImagePicker
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _fotoFile = image;
      });
    }
  }

  // Pilih Video menggunakan ImagePicker
  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (video != null) {
      setState(() {
        _videoFile = video;
      });
    }
  }

  // Submit Laporan
  void _submitLaporan() async {
    final laporanProvider = Provider.of<LaporanProvider>(context, listen: false);

    if (_selectedJalanId == null) {
      _showSnackBar('Ruas jalan tol wajib dipilih!');
      return;
    }
    if (_lokasiController.text.trim().isEmpty) {
      _showSnackBar('Lokasi detail wajib diisi!');
      return;
    }
    if (_jenisController.text.trim().isEmpty) {
      _showSnackBar('Jenis kecelakaan wajib diisi!');
      return;
    }
    if (_latitude == null || _longitude == null) {
      _showSnackBar('Koordinat GPS wajib didapatkan!');
      return;
    }

    final success = await laporanProvider.kirimLaporan(
      jalanId: _selectedJalanId!,
      jenisKecelakaan: _jenisController.text.trim(),
      lokasi: _lokasiController.text.trim(),
      latitude: _latitude!,
      longitude: _longitude!,
      penyebab: _penyebabController.text.trim(),
      dampak: _dampakController.text.trim(),
      fotoFile: _fotoFile,
      videoFile: _videoFile,
    );

    if (success) {
      _showSnackBar('Laporan Anda berhasil dikirim ke server!');
      // Reset Form
      _lokasiController.clear();
      _jenisController.clear();
      _penyebabController.clear();
      _dampakController.clear();
      setState(() {
        _fotoFile = null;
        _videoFile = null;
      });
    } else {
      _showSnackBar(laporanProvider.errorMessage ?? 'Gagal mengirimkan laporan.');
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final jalanProvider = Provider.of<JalanProvider>(context);
    final laporanProvider = Provider.of<LaporanProvider>(context);

    // Ambil tanggal hari ini secara dinamis
    final todayDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    final todayTime = DateFormat('HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporkan Kecelakaan', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bantu kami tingkatkan keselamatan jalan dengan laporan Anda',
              style: TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            // Tanggal dan Waktu (Dinamis)
            Row(
              children: [
                Expanded(
                  child: _buildReadonlyField('Tanggal Kejadian *', todayDate),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildReadonlyField('Waktu *', todayTime),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Ruas Jalan Tol (Dinamis dari API)
            const Text('Ruas Jalan Tol *', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _selectedJalanId,
              decoration: const InputDecoration(hintText: 'Pilih jalan tol'),
              items: jalanProvider.jalans.map((jalan) {
                return DropdownMenuItem<int>(
                  value: jalan.id,
                  child: Text(jalan.namaJalan),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedJalanId = val),
            ),
            const SizedBox(height: 16),
            
            // Lokasi Detail
            _buildTextField('Lokasi Detail Kejadian *', _lokasiController, 'Contoh: Lajur kanan KM 42'),
            
            // Titik Koordinat (GPS asli via geolocator)
            const Text('Titik Koordinat *', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _latitude != null ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                border: Border.all(
                  color: _latitude != null 
                      ? AppColors.success.withValues(alpha: 0.5) 
                      : AppColors.warning.withValues(alpha: 0.5)
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _latitude != null ? Icons.check_circle : Icons.gps_not_fixed, 
                    color: _latitude != null ? AppColors.success : AppColors.warning
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _locationStatus,
                          style: TextStyle(
                            color: _latitude != null ? AppColors.success : AppColors.warning, 
                            fontSize: 13, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        if (_latitude != null && _longitude != null)
                          Text(
                            'Lat: $_latitude, Long: $_longitude',
                            style: const TextStyle(fontSize: 12, color: AppColors.secondary),
                          ),
                      ],
                    ),
                  ),
                  if (_isLocating)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: _determinePosition,
                    )
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTextField('Jenis Kecelakaan *', _jenisController, 'Contoh: Tabrakan beruntun'),
            _buildTextField('Penyebab (Opsional)', _penyebabController, 'Mengantuk, rem blong, dll'),
            _buildTextField('Dampak (Opsional)', _dampakController, '2 luka berat, 1 meninggal, dll'),
            
            // Foto Bukti (Dinamis dengan ImagePicker)
            const Text('Foto Bukti *', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: _fotoFile != null 
                    ? Column(
                        children: [
                          const Icon(Icons.check_circle, size: 40, color: AppColors.success),
                          const SizedBox(height: 8),
                          Text('Foto Terpilih: ${_fotoFile!.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextButton(onPressed: _pickImage, child: const Text('Ubah Foto')),
                        ],
                      )
                    : const Column(
                        children: [
                          Icon(Icons.image, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Pilih Foto', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          Text('Max 5MB. Format: JPG, PNG', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Video Bukti
            const Text('Video Bukti (Opsional)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: _videoFile != null
                    ? Column(
                        children: [
                          const Icon(Icons.check_circle, size: 40, color: AppColors.success),
                          const SizedBox(height: 8),
                          Text('Video Terpilih: ${_videoFile!.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextButton(onPressed: _pickVideo, child: const Text('Ubah Video')),
                        ],
                      )
                    : const Column(
                        children: [
                          Icon(Icons.videocam, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Pilih Video', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          Text('Max 50MB. Format: MP4, MOV', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: laporanProvider.isLoading ? null : _submitLaporan,
                child: laporanProvider.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Kirim Laporan'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReadonlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(value, style: const TextStyle(color: AppColors.textLight)),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
