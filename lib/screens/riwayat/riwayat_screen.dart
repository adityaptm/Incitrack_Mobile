import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Laporan Saya', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 4, 
        itemBuilder: (context, index) {
          final statusList = ['Valid', 'Pending', 'Invalid', 'Valid'];
          final status = statusList[index];
          
          Color statusColor;
          if (status == 'Valid') statusColor = AppColors.success;
          else if (status == 'Invalid') statusColor = AppColors.danger;
          else statusColor = AppColors.warning;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                      const Text(
                        'Tabrakan Beruntun',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.calendar_today, size: 14, color: AppColors.textLight),
                      SizedBox(width: 6),
                      Text('12 Okt 2026', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jalan Tol: Tol Jakarta - Cikampek',
                    style: TextStyle(color: AppColors.secondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
