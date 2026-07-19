import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/laporan_provider.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        Provider.of<LaporanProvider>(context, listen: false)
            .fetchUserLaporans(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final laporanProvider = Provider.of<LaporanProvider>(context);
    final userLaporans = laporanProvider.userLaporans;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Laporan Saya', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: laporanProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userLaporans.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off, size: 60, color: AppColors.textLight),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada riwayat laporan.',
                        style: TextStyle(color: AppColors.textLight, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: userLaporans.length, 
                  itemBuilder: (context, index) {
                    final laporan = userLaporans[index];
                    final status = laporan.status;
                    
                    Color statusColor;
                    if (status.toLowerCase() == 'valid') {
                      statusColor = AppColors.success;
                    } else if (status.toLowerCase() == 'invalid') {
                      statusColor = AppColors.danger;
                    } else {
                      statusColor = AppColors.warning;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    laporan.jenis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 14, color: AppColors.textLight),
                                const SizedBox(width: 6),
                                Text(
                                  laporan.createdAt.length > 10 
                                      ? laporan.createdAt.substring(0, 10) 
                                      : laporan.createdAt, 
                                  style: const TextStyle(color: AppColors.textLight, fontSize: 13)
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '📍 Lokasi: ${laporan.lokasi}',
                              style: const TextStyle(color: AppColors.secondary, fontSize: 14),
                            ),
                            if (laporan.jalan != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                '🛣️ Ruas Tol: ${laporan.jalan!.namaJalan}',
                                style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
