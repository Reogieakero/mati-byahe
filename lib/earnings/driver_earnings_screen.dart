import 'package:flutter/material.dart';

import '../core/constant/app_colors.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Trip History',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkNavy,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Earnings Overview',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 14),
                _EarningsSummary(),
                SizedBox(height: 18),
                Text(
                  'Recent Trips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child: _TripList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EarningsSummary extends StatelessWidget {
  const _EarningsSummary();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _SummaryCard(
            title: 'Today',
            amount: '₱150.00',
            accent: AppColors.primaryBlue,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Week',
            amount: '₱350.00',
            accent: AppColors.primaryYellow,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color accent;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                color: accent,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(
                color: AppColors.darkNavy,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripItem {
  final String id;
  final String dateTime;
  final String amount;
  final double rating;

  const _TripItem({
    required this.id,
    required this.dateTime,
    required this.amount,
    required this.rating,
  });
}

class _TripList extends StatelessWidget {
  const _TripList();

  @override
  Widget build(BuildContext context) {
    const trips = [
      _TripItem(
        id: 'Trip #5024',
        dateTime: 'Jan 10, 2026 · 14:10',
        amount: '₱150.00',
        rating: 5.0,
      ),
      _TripItem(
        id: 'Trip #5025',
        dateTime: 'Jan 11, 2026 · 14:11',
        amount: '₱190.00',
        rating: 4.8,
      ),
      _TripItem(
        id: 'Trip #5026',
        dateTime: 'Jan 12, 2026 · 14:12',
        amount: '₱230.00',
        rating: 4.6,
      ),
      _TripItem(
        id: 'Trip #5027',
        dateTime: 'Jan 13, 2026 · 09:35',
        amount: '₱205.00',
        rating: 4.9,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 10),
      itemBuilder: (context, index) => _TripTile(item: trips[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: trips.length,
    );
  }
}

class _TripTile extends StatelessWidget {
  final _TripItem item;

  const _TripTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final ratingText = item.rating.toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 21,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.id,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.dateTime,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textGrey.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      '★★★★★',
                      style: TextStyle(
                        color: AppColors.primaryYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ratingText,
                      style: const TextStyle(
                        color: Color(0xFFB08F1C),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              item.amount,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
