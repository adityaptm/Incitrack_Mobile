import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/laporan_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil semua laporan saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporanProvider>(context, listen: false).fetchAllLaporans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final laporanProvider = Provider.of<LaporanProvider>(context);
    final validLaporans = laporanProvider.laporans;

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
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: const Icon(Icons.location_on, size: 70, color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'INCITRACK Mobile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Peta sebaran dan pelaporan insiden lalu lintas jalan tol Indonesia secara real-time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Peta Interaktif Utama (Pengganti Leaflet.js di Web)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Peta Sebaran Insiden',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 350,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Widget Peta OpenStreetMap
                    FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(-6.200000, 106.816666), // default center Jakarta
                        initialZoom: 10,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.incitrack.mobile',
                        ),
                        // Menampilkan Marker Koordinat Kecelakaan secara Real-time dari API
                        MarkerLayer(
                          markers: validLaporans.map((laporan) {
                            return Marker(
                              point: LatLng(laporan.latitude, laporan.longitude),
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  _showIncidentDetailDialog(context, laporan);
                                },
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    if (laporanProvider.isLoading)
                      Container(
                        color: Colors.white.withValues(alpha: 0.6),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats Section
            Container(
              width: double.infinity,
              color: AppColors.secondary,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(validLaporans.length.toString(), 'Laporan Valid'),
                  _buildStatItem('15%', 'Tingkat Mitigasi'),
                ],
              ),
            ),
            const SizedBox(height: 30),
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
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFFBDC3C7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Tampilkan Popup Dialog saat Marker Peta ditap
  void _showIncidentDetailDialog(BuildContext context, dynamic laporan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            laporan.jenis,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📍 Lokasi: ${laporan.lokasi}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (laporan.jalan != null) ...[
                Text('🛣️ Jalan Tol: ${laporan.jalan!.namaJalan}'),
                const SizedBox(height: 8),
              ],
              Text('🕒 Kejadian: ${laporan.createdAt}'),
              const SizedBox(height: 8),
              if (laporan.penyebab != null) ...[
                Text('Penyebab: ${laporan.penyebab}'),
                const SizedBox(height: 8),
              ],
              if (laporan.dampak != null) ...[
                Text('Dampak: ${laporan.dampak}'),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            )
          ],
        );
      },
    );
  }
}
