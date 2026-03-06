import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

/// A minimal widget that mimics the "available passenger" / "active ride"
/// cards shown on the driver home screen screenshots.
///
/// The first state shows a single available passenger with an "Accept Ride"
/// button; tapping it flips into the active ride state, which shows a different
/// passenger and displays "Start Trip" and "Cancel" buttons.
class DriverPassengerWidget extends StatefulWidget {
  final String email;

  const DriverPassengerWidget({super.key, required this.email});

  @override
  State<DriverPassengerWidget> createState() => _DriverPassengerWidgetState();
}

class _DriverPassengerWidgetState extends State<DriverPassengerWidget> {
  bool _accepted = false;

  // sample data; in a real app these would come from a backend
  final Map<String, dynamic> _available = {
    'name': 'Ben',
    'fare': 200,
    'pickup': 'Market St',
    'drop': 'Park Ave',
  };

  final Map<String, dynamic> _active = {
    'name': 'Ana',
    'fare': 120,
    'pickup': 'Acad St',
    'drop': 'City Mall',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: _accepted ? _buildActiveCard() : _buildAvailableCard(),
    );
  }

  Widget _buildAvailableCard() {
    return _buildCard(
      title: 'Available Passenger',
      name: _available['name'],
      fare: _available['fare'],
      pickup: _available['pickup'],
      drop: _available['drop'],
      actionLabel: 'Accept Ride',
      onAction: () => setState(() => _accepted = true),
      gradient: true,
    );
  }

  Widget _buildActiveCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.directions_car,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Active Ride',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'In Progress',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _active['name'][0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _active['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '₱${_active['fare']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: const [
                  Icon(Icons.location_on, size: 16),
                  SizedBox(height: 4),
                  Icon(Icons.more_vert, size: 12, color: Colors.grey),
                  SizedBox(height: 4),
                  Icon(Icons.flag, size: 16),
                ],
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_active['pickup']),
                  const SizedBox(height: 20),
                  Text(_active['drop']),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Trip started')),
                    );
                  },
                  child: const Text('Start Trip'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => setState(() => _accepted = false),
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String name,
    required num fare,
    required String pickup,
    required String drop,
    required String actionLabel,
    required VoidCallback onAction,
    Widget? extraButton,
    bool gradient = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: gradient ? null : Colors.white,
        gradient: gradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryYellow.withOpacity(0.8),
                  AppColors.bgYellowMid,
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                '₱$fare',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(pickup)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.flag, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(drop)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel),
                ),
              ),
              if (extraButton != null) ...[
                const SizedBox(width: 12),
                SizedBox(width: 80, child: extraButton),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
