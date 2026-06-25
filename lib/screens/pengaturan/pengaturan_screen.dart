import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pengaturan Profil', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.danger),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Aditya PTM',
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              const Text('Email', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'adit@incitrack.com',
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              const Text('Password (Kosongkan jika tidak ingin mengubah)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
              const SizedBox(height: 8),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  fillColor: const Color(0xFFF1F2F6),
                ),
              ),
              const SizedBox(height: 4),
              const Text('Ubah password sedang dinonaktifkan pada versi ini.', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
