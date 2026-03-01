import 'package:flutter/material.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF3F3F3);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'TRIP HISTORY',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Earnings',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _EarningCard(
                      title: 'Today',
                      amount: '₱150.00',
                      bgColor: Color(0xFFCDE8CE),
                      titleColor: Color(0xFF58A65B),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _EarningCard(
                      title: 'Week',
                      amount: '₱350.00',
                      bgColor: Color(0xFFE8DFF0),
                      titleColor: Color(0xFFD66BE0),
                      borderColor: Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Recent Trips',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              const Expanded(child: _TripList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarningCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color bgColor;
  final Color titleColor;
  final Color borderColor;

  const _EarningCard({
    required this.title,
    required this.amount,
    required this.bgColor,
    required this.titleColor,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 3),
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
                fontSize: 20,
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripList extends StatelessWidget {
  const _TripList();

  @override
  Widget build(BuildContext context) {
    const trips = [
      _TripItem(
        id: 'Trip #5024',
        dateTime: 'Jan 10, 2026 · 14:10',
        rating: '★★★★★ 5.0',
        amount: '₱150.00',
      ),
      _TripItem(
        id: 'Trip #5025',
        dateTime: 'Jan 11, 2026 · 14:11',
        rating: '★★★★☆ 4.8',
        amount: '₱190.00',
      ),
      _TripItem(
        id: 'Trip #5026',
        dateTime: 'Jan 12, 2026 · 14:12',
        rating: '★★★★☆ 4.6',
        amount: '₱230.00',
      ),
      _TripItem(
        id: 'Trip #5026',
        dateTime: 'Jan 12, 2026 · 14:12',
        rating: '★★★★☆ 4.6',
        amount: '₱230.00',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 10),
      itemBuilder: (context, index) => _TripTile(item: trips[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: trips.length,
    );
  }
}

class _TripItem {
  final String id;
  final String dateTime;
  final String rating;
  final String amount;

  const _TripItem({
    required this.id,
    required this.dateTime,
    required this.rating,
    required this.amount,
  });
}

class _TripTile extends StatelessWidget {
  final _TripItem item;

  const _TripTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD3D9E3), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withValues(alpha: 0.08),
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
              color: const Color(0xFFF2F4F7),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: const Icon(Icons.directions_car_rounded, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.dateTime,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.52),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    text: item.rating.substring(0, 5),
                    style: const TextStyle(
                      color: Color(0xFFF4B400),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: item.rating.substring(5),
                        style: const TextStyle(
                          color: Color(0xFFE0A900),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F9F6),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFC7EEE7), width: 1),
            ),
            child: Text(
              item.amount,
              style: const TextStyle(
                color: Color(0xFF1E9F98),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
