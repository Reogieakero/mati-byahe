import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';

class DriverDetailsView extends StatelessWidget {
  final Map<String, dynamic> driverData;

  const DriverDetailsView({super.key, required this.driverData});

  @override
  Widget build(BuildContext context) {
    final String name = driverData['name']?.toString() ?? 'Unknown Driver';
    final String plate = driverData['plate']?.toString() ?? 'No Plate Info';
    final String vehicle = driverData['vehicle_type']?.toString() ?? 'Vehicle';
    final String color = driverData['color']?.toString() ?? 'Not Specified';
    final String photoUrl = driverData['photo_url']?.toString() ?? '';

    final ignoredKeys = [
      'name',
      'plate',
      'vehicle_type',
      'color',
      'photo_url',
      'id',
    ];
    final otherData = driverData.entries
        .where((entry) => !ignoredKeys.contains(entry.key.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "DRIVER PROFILE",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.darkNavy,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.darkNavy,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.darkNavy.withOpacity(0.1),
                    backgroundImage: photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : null,
                    child: photoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.darkNavy,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoTile(
              label: "PLATE NUMBER",
              value: plate,
              icon: Icons.tag,
            ),
            const SizedBox(height: 12),
            _buildInfoTile(
              label: "VEHICLE TYPE",
              value: vehicle,
              icon: Icons.directions_car_filled_rounded,
            ),
            const SizedBox(height: 12),
            _buildInfoTile(
              label: "VEHICLE COLOR",
              value: color,
              icon: Icons.palette_outlined,
            ),
            if (otherData.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  " ADDITIONAL INFORMATION",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...otherData.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildInfoTile(
                    label: entry.key
                        .replaceFirst(entry.key[0], entry.key[0].toUpperCase())
                        .replaceAll('_', ' '),
                    value: entry.value.toString(),
                    icon: Icons.info_outline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.darkNavy.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.darkNavy, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
}
