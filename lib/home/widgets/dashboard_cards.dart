import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class DashboardCards extends StatelessWidget {
  final int tripCount;
  final String plateNumber;
  final String email;
  final String role;

  const DashboardCards({
    super.key,
    required this.tripCount,
    required this.plateNumber,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDriver = role.toLowerCase() == 'driver';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // Navy Blue is dominant, White acts as a "line/sheen" gradient
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 1.0],
            colors: [
              AppColors.darkNavy,
              AppColors.darkNavy.withBlue(
                100,
              ), // Slight lighter navy transition
              AppColors.darkNavy,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkNavy.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // This adds the "White Line Gradient" effect across the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
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
                            color: Colors.white.withOpacity(0.1),
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
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isDriver ? 'ONLINE' : 'ONGOING',
                          style: TextStyle(
                            color: isDriver ? Colors.greenAccent : Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white.withOpacity(0.05), height: 1),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isDriver
                      ? _buildDriverStats()
                      : _buildPassengerStats(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
              border: Border.all(color: Colors.white.withOpacity(0.03)),
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
                  plateNumber,
                  style: TextStyle(
                    color: AppColors.primaryYellow.withOpacity(0.9),
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
