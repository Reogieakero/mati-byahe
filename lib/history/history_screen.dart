import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';
import '../core/database/local_database.dart';
import 'widgets/history_header.dart';
import 'widgets/history_tile.dart';

class HistoryScreen extends StatefulWidget {
  final String email;
  const HistoryScreen({super.key, required this.email});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
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
            const HistoryHeader(),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: LocalDatabase().getTrips(widget.email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final trips = snapshot.data ?? [];

                  if (trips.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      return HistoryTile(trip: trips[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 60,
            color: AppColors.darkNavy.withOpacity(0.2),
          ),
          const SizedBox(height: 10),
          const Text(
            "No past trips found",
            style: TextStyle(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
