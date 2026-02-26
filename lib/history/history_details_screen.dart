import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constant/app_colors.dart';

class HistoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> trip;

  const HistoryDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final DateTime date =
        DateTime.tryParse(trip['date'] ?? '') ?? DateTime.now();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryYellow.withOpacity(0.2),
              Colors.white,
              AppColors.primaryYellow.withOpacity(0.1),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                "TRIP DETAILS",
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
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.darkNavy,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("ROUTE INFORMATION"),
                    const SizedBox(height: 16),
                    _buildRouteCard(),
                    const SizedBox(height: 32),
                    _buildSectionHeader("PAYMENT & FARE"),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      "Total Fare",
                      "₱${trip['fare']}",
                      isBold: true,
                    ),
                    _buildDetailRow(
                      "Gas Tier",
                      trip['gas_tier']?.toString().toUpperCase() ?? "N/A",
                    ),
                    const Divider(height: 32, color: AppColors.softWhite),
                    _buildSectionHeader("TIME LOGS"),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      "Date",
                      DateFormat('MMMM dd, yyyy').format(date),
                    ),
                    _buildDetailRow(
                      "Pickup Time",
                      trip['start_time'] ?? "--:--",
                    ),
                    _buildDetailRow(
                      "Drop-off Time",
                      trip['end_time'] ?? "--:--",
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader("PARTICIPANTS"),
                    const SizedBox(height: 12),
                    _buildDetailRow("Driver ID", trip['driver_id'] ?? "N/A"),
                    _buildDetailRow(
                      "Passenger ID",
                      trip['passenger_id'] ?? "N/A",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.softWhite),
      ),
      child: Row(
        children: [
          Column(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.primaryBlue),
              Container(
                width: 1,
                height: 40,
                color: AppColors.textGrey.withOpacity(0.3),
              ),
              const Icon(Icons.location_on, size: 12, color: Colors.redAccent),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRoutePoint("From", trip['pickup']),
                const SizedBox(height: 24),
                _buildRoutePoint("To", trip['drop_off']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutePoint(String label, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          address,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                color: AppColors.darkNavy,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
