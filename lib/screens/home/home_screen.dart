import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 40),
              decoration: BoxDecoration(
                color: AppColors.background,
                // Optional subtle gradient matching the css ::after
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Hero Image (Placeholder for it.png)
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: const Icon(Icons.location_on, size: 80, color: AppColors.primary),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tentang INCITRACK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Platform visualisasi dan pelaporan kecelakaan lalu lintas secara real-time untuk meningkatkan keselamatan jalan tol di Indonesia.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Ini akan diatur navigasinya oleh BottomNavigationBar, 
                      // tapi bisa juga langsung arahkan index
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Laporkan Sekarang', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),

            // Stats Section
            Container(
              width: double.infinity,
              color: AppColors.secondary,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  _buildStatItem('1.205', 'Total Kecelakaan Tahun Ini'),
                  const SizedBox(height: 30),
                  _buildStatItem('842', 'Laporan Terverifikasi'),
                  const SizedBox(height: 30),
                  _buildStatItem('15%', 'Peningkatan Keselamatan'),
                ],
              ),
            ),

            // Content Grid Section
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Pelaporan yang akurat dapat membantu pemerintah memperbaiki titik rawan kecelakaan.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Image Placeholder for image 6.png
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        )
                      ],
                    ),
                    child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Image Placeholder for maps.jpg
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        )
                      ],
                    ),
                    child: const Center(child: Icon(Icons.map, size: 50, color: Colors.grey)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Visualisasi data kami membantu memahami area berbahaya secara lebih mudah.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFBDC3C7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
