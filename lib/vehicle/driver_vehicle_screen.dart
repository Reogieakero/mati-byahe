import 'package:flutter/material.dart';

import '../core/constant/app_colors.dart';

class DriverVehicleScreen extends StatefulWidget {
  const DriverVehicleScreen({super.key});

  @override
  State<DriverVehicleScreen> createState() => _DriverVehicleScreenState();
}

class _DriverVehicleScreenState extends State<DriverVehicleScreen> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgYellowStart,
              AppColors.bgYellowMid,
              AppColors.bgYellowEnd,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            children: [
              const Text(
                'Vehicle',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 14),
              _statusCard(),
              const SizedBox(height: 14),
              _vehicleSummaryCard(),
              const SizedBox(height: 18),
              _sectionLabel('VEHICLE MANAGEMENT'),
              const SizedBox(height: 10),
              _groupCard(
                children: [
                  _menuItem(
                    icon: Icons.badge_outlined,
                    title: 'Vehicle Documents',
                    subtitle: 'Registration, OR/CR, and permit files',
                    onTap: () => _showSoon('Vehicle Documents'),
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.build_circle_outlined,
                    title: 'Maintenance Log',
                    subtitle: 'Track service dates and reminders',
                    onTap: () => _showSoon('Maintenance Log'),
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.security_outlined,
                    title: 'Insurance & Coverage',
                    subtitle: 'Policy details and expiry date',
                    onTap: () => _showSoon('Insurance & Coverage'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _sectionLabel('SAFETY & SETTINGS'),
              const SizedBox(height: 10),
              _groupCard(
                children: [
                  _menuItem(
                    icon: Icons.speed_rounded,
                    title: 'Trip Safety Checklist',
                    subtitle: 'Pre-ride checklist before going online',
                    onTap: () => _showSoon('Trip Safety Checklist'),
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.edit_road_rounded,
                    title: 'Update Vehicle Info',
                    subtitle: 'Edit plate number, color, and model',
                    onTap: () => _showSoon('Update Vehicle Info'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryBlue.withValues(alpha: 0.12)
                  : Colors.grey.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive
                  ? Icons.check_circle_rounded
                  : Icons.pause_circle_rounded,
              color: isActive ? AppColors.primaryBlue : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive
                      ? 'Vehicle Status: Active'
                      : 'Vehicle Status: Offline',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isActive
                      ? 'You can receive bookings with this vehicle.'
                      : 'Turn on to start receiving ride requests.',
                  style: TextStyle(
                    color: AppColors.textGrey.withValues(alpha: 0.95),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isActive,
            activeThumbColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.30),
            onChanged: (v) => setState(() => isActive = v),
          ),
        ],
      ),
    );
  }

  Widget _vehicleSummaryCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 36,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toyota Vios 2021',
                  style: TextStyle(
                    color: AppColors.darkNavy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Plate: CLB 4930',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Color: White · Seats: 4',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: AppColors.textGrey.withValues(alpha: 0.8),
        letterSpacing: 1.6,
      ),
    );
  }

  Widget _groupCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    indent: 58,
    endIndent: 16,
    color: Colors.grey.withValues(alpha: 0.10),
  );

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryBlue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textGrey.withValues(alpha: 0.95),
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textGrey,
        size: 22,
      ),
    );
  }

  void _showSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is ready for backend integration.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
