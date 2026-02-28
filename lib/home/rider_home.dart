import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';
import 'widgets/dashboard_cards.dart';
import 'widgets/action_grid_widget.dart';
import 'widgets/home_header.dart';

class Ride {
  final String id;
  final String name;
  final String pickup;
  final String destination;
  final double fare;
  final String avatarUrl;

  Ride({
    required this.id,
    required this.name,
    required this.pickup,
    required this.destination,
    required this.fare,
    this.avatarUrl = '',
  });
}

class RiderHomeScreen extends StatefulWidget {
  final String email;

  const RiderHomeScreen({super.key, required this.email});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen>
    with TickerProviderStateMixin {
  List<Ride> _rides = []; // start empty; passengers add rides dynamically
  Ride? _activeRide;

  late AnimationController _badgePulseController;

  @override
  void initState() {
    super.initState();
    // sample data for demonstration; in production this will be replaced by real-time requests
    _rides = [
      Ride(
        id: '1',
        name: 'Ana',
        pickup: 'Acad St',
        destination: 'City Mall',
        fare: 120.0,
      ),
      Ride(
        id: '2',
        name: 'Ben',
        pickup: 'Market St',
        destination: 'Park Ave',
        fare: 200.0,
      ),
    ];

    _badgePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _badgePulseController.dispose();
    super.dispose();
  }

  void _acceptRide(Ride ride) async {
    setState(() {
      _activeRide = ride;
      _rides.removeWhere((r) => r.id == ride.id);
    });
  }

  Widget _buildRidesList() {
    // pinned active ride card
    List<Widget> items = [];
    if (_activeRide != null) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ActiveRideCard(
            ride: _activeRide!,
            badgePulse: _badgePulseController,
            onCancel: () {
              setState(() {
                _activeRide = null;
              });
            },
          ),
        ),
      );
    }
    if (_rides.isEmpty) {
      items.add(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 56,
                color: AppColors.darkNavy.withOpacity(0.3),
              ),
              SizedBox(height: 12),
              Text(
                'No passengers nearby',
                style: TextStyle(color: AppColors.darkNavy.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      );
    } else {
      items.addAll(
        _rides.map((ride) {
          return RideCard(ride: ride, onAccept: () => _acceptRide(ride));
        }).toList(),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      itemBuilder: (_, idx) => items[idx],
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: items.length,
    );
  }

  Widget _buildGradientBackground({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _buildGradientBackground(
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 10),
              DashboardCards(
                tripCount: _rides.length,
                driverName: 'You',
                plateNumber: '—',
                email: widget.email,
                role: 'RIDER',
              ),
              const SizedBox(height: 10),
              const ActionGridWidget(),
              const SizedBox(height: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Text(
                        'Available Passengers',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0B1220),
                        ),
                      ),
                    ),
                    Expanded(child: _buildRidesList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onAccept;

  const RideCard({super.key, required this.ride, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.06),
            offset: const Offset(0, 8),
            blurRadius: 22,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFEFE5D8),
            child: Text(ride.name[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ride.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '₱${ride.fare.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0B1220),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ride.pickup,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ride.destination,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(96, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Accept Ride',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveRideCard extends StatefulWidget {
  final Ride ride;
  final AnimationController badgePulse;
  final VoidCallback onCancel;

  const ActiveRideCard({
    super.key,
    required this.ride,
    required this.badgePulse,
    required this.onCancel,
  });

  @override
  State<ActiveRideCard> createState() => _ActiveRideCardState();
}

class _ActiveRideCardState extends State<ActiveRideCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Active Ride" label with status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_taxi,
                    size: 20,
                    color: Color(0xFF28C76F),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Active Ride',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue.withOpacity(0.7),
                      letterSpacing: 0.5,
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
                  color: const Color(0xFF28C76F).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'In Progress',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF28C76F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Passenger info
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEFE5D8),
                child: Text(
                  widget.ride.name[0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ride.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₱${widget.ride.fare.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Location details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: AppColors.primaryBlue.withOpacity(0.6),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 2,
                      height: 20,
                      color: AppColors.primaryBlue.withOpacity(0.2),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.place,
                      size: 18,
                      color: AppColors.primaryBlue.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNavy.withOpacity(0.5),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.ride.pickup,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destination',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNavy.withOpacity(0.5),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.ride.destination,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNavy,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Start Trip',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    side: BorderSide(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 50,
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(
                      color: Colors.red.withOpacity(0.3),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.close, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
