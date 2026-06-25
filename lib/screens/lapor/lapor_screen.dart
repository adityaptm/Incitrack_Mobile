import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LaporScreen extends StatefulWidget {
  const LaporScreen({Key? key}) : super(key: key);

  @override
  State<LaporScreen> createState() => _LaporScreenState();
}

class _LaporScreenState extends State<LaporScreen> {
  final _lokasiController = TextEditingController();
  final _jenisController = TextEditingController();
  final _penyebabController = TextEditingController();
  final _dampakController = TextEditingController();
  String? _jalanTol;

  @override
  Widget build(BuildContext context) {
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
            
            // Tanggal dan Waktu (Readonly style)
            Row(
              children: [
                Expanded(
                  child: _buildReadonlyField('Tanggal Kejadian *', '2026-10-12'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildReadonlyField('Waktu *', '14:30 Siang'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Ruas Jalan Tol
            const Text('Ruas Jalan Tol *', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _jalanTol,
              decoration: const InputDecoration(hintText: 'Pilih jalan tol'),
              items: ['Tol Jakarta - Cikampek', 'Tol Cipularang', 'Tol Jagorawi']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _jalanTol = val),
            ),
            const SizedBox(height: 16),
            
            // Lokasi Detail
            _buildTextField('Lokasi Detail Kejadian *', _lokasiController, 'Contoh: Lajur kanan setelah rest area'),
            
            // Titik Koordinat (Map Box simulation)
            const Text('Titik Koordinat *', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                border: Border.all(color: AppColors.success.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle, color: AppColors.success),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Lokasi GPS Anda berhasil dideteksi dan dikunci otomatis.',
                      style: TextStyle(color: AppColors.success, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTextField('Jenis Kecelakaan *', _jenisController, 'Contoh: Tabrakan beruntun'),
            _buildTextField('Penyebab (Opsional)', _penyebabController, 'Mengantuk, rem blong, dll'),
            _buildTextField('Dampak (Opsional)', _dampakController, '2 luka berat, 1 meninggal, dll'),
            
            // Foto
            const Text('Foto Bukti *', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: const [
                  Icon(Icons.image, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Pilih Foto', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  Text('Max 5MB. Format: JPG, PNG', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Video
            const Text('Video Bukti (Opsional)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: const [
                  Icon(Icons.videocam, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Pilih Video', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  Text('Max 50MB. Format: MP4, MOV', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Kirim Laporan'),
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
