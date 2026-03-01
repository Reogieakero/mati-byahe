import 'package:flutter/material.dart';

import '../core/constant/app_texts.dart';
import '../earnings/driver_earnings_screen.dart';
import '../home/home_screen.dart';
import '../history/history_screen.dart';
import '../profile/driver_profile_screen.dart';
import '../profile/profile_screen.dart';
import '../report/report_history_screen.dart';

class NavigationScreens {
  static List<Widget> getScreens(String email, String role) {
<<<<<<< Updated upstream
    final String normalizedRole = role.toLowerCase();

    if (normalizedRole == 'driver') {
=======
    final normalizedRole = role.trim().toLowerCase();
    final bool isDriver =
        normalizedRole == 'driver' || normalizedRole == 'rider';

    // ✅ DRIVER NAV: MUST MATCH DriverNavBar = 4 items
    if (isDriver) {
>>>>>>> Stashed changes
      return [
        HomeScreen(email: email, role: role),
        const DriverEarningsScreen(),
        _placeholder(AppTexts.navVehicle),
<<<<<<< Updated upstream
        ProfileScreen(email: email, role: role),
=======
        DriverProfileScreen(email: email), // ✅ YOUR DRIVER DESIGN HERE
>>>>>>> Stashed changes
      ];
    }

    // ✅ PASSENGER NAV: keep original 5 items
    return [
      HomeScreen(email: email, role: role),
      HistoryScreen(email: email),
      _placeholder("SCANNER"),
      const ReportHistoryScreen(),
      ProfileScreen(email: email, role: role),
    ];
  }

  static Widget _placeholder(String text) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
