import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class DashboardCards extends StatelessWidget {
  final int tripCount;
  final String driverName;
  final String plateNumber;
  final String email;
  final String role;

  const DashboardCards({
    super.key,
    required this.tripCount,
    required this.driverName,
    required this.plateNumber,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the current user is a driver
    final bool isDriver = role.toLowerCase() == 'driver';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.darkNavy,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkNavy.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Section (Common for both)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email.split('@')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          role.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primaryYellow.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDriver
                          ? Colors.greenAccent.withOpacity(0.2)
                          : const Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isDriver ? 'ONLINE' : 'ONGOING',
                      style: TextStyle(
                        color: isDriver
                            ? Colors.greenAccent
                            : AppColors.darkNavy,
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.05), height: 1),

            // Stats Section: Conditional logic for Driver vs Passenger
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: isDriver ? _buildDriverStats() : _buildPassengerStats(),
            ),
          ],
        ),
      ),
    );
  }

  // New Driver Stats: Passengers and Ratings
  Widget _buildDriverStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatColumn('PASSENGERS', '12', Icons.people_alt_rounded),
        _buildStatDivider(),
        _buildStatColumn(
          'TODAY TRIP',
          '$tripCount',
          Icons.directions_car_rounded,
        ),
        _buildStatDivider(),
        _buildStatColumn('RATING', '4.9', Icons.star_rounded, isYellow: true),
      ],
    );
  }

  // Original Passenger Layout (Unchanged Content)
  Widget _buildPassengerStats() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TODAY TRIP',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '$tripCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Driver',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  driverName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  plateNumber,
                  style: TextStyle(
                    color: AppColors.primaryYellow.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper for Driver stats
  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon, {
    bool isYellow = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.bold,
            fontSize: 9,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isYellow ? AppColors.primaryYellow : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }
}
