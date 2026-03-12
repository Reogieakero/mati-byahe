import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';

class PaymentInfoCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  const PaymentInfoCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _row("Total Fare", "₱${trip['fare']}", isBold: true),
          const SizedBox(height: 12),
          _row("Gas Tier", trip['gas_tier']?.toString().toUpperCase() ?? "N/A"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _row("Driver", trip['driver_name'] ?? "N/A"),
          const SizedBox(height: 12),
          _row("Plate No.", trip['plate_number'] ?? "N/A"),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
            color: AppColors.darkNavy,
          ),
        ),
      ],
    );
  }
}
