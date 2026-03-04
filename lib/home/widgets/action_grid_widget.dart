import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';
import '../../other screens/news_screen.dart';
import '../../other screens/report_screen.dart';
import '../../other screens/tracking_screen.dart';
import '../../qrscanner/qr_scanner_view.dart';

class ActionGridWidget extends StatelessWidget {
  const ActionGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(Icons.campaign_rounded, "Report", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportScreen()),
            );
          }),
          _buildItem(Icons.newspaper_rounded, "News", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsScreen()),
            );
          }),
          _buildItem(Icons.analytics_rounded, "Track", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TrackingScreen()),
            );
          }),
          _buildItem(Icons.qr_code_scanner_rounded, "Scan QR", () {
            _openQrScanner(context);
          }),
        ],
      ),
    );
  }

  void _openQrScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerView(
          onQrCodeDetected: (qrCode) {
            // Handle the detected QR code here
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Scanned: $qrCode')));
          },
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.darkNavy,
            ),
          ),
        ],
      ),
    );
  }
}
