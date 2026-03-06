import 'package:flutter/material.dart';
import '../../../core/constant/app_colors.dart';

class TripInfoCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  const TripInfoCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                left: 24.5, // Centers the line under the 18px icons
                top: 36, // Starts after the pickup icon
                bottom: 36, // Ends before the drop-off icon
                child: Container(width: 1.5, color: Colors.grey.shade200),
              ),
              Column(
                children: [
                  _buildLocationRow(
                    Icons.radio_button_checked,
                    "PICKUP LOCATION",
                    trip['pickup'] ?? "N/A",
                    AppColors.primaryYellow,
                  ),
                  _buildLocationRow(
                    Icons.location_on,
                    "DROP-OFF LOCATION",
                    trip['drop_off']?.toString().isNotEmpty == true
                        ? trip['drop_off']
                        : "---",
                    Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    "START TIME",
                    trip['start_time'] ?? "--:--",
                  ),
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                ),
                Expanded(
                  child: _buildTimeInfo(
                    "END TIME",
                    trip['end_time'] ?? "--:--",
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    IconData icon,
    String label,
    String val,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  val,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(
    String label,
    String time, {
    TextAlign textAlign = TextAlign.start,
  }) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.start
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.darkNavy,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
