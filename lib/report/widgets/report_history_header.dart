import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';

class ReportHistoryAppBar extends StatelessWidget {
  const ReportHistoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        "REPORT HISTORY",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: AppColors.darkNavy,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
