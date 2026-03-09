import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constant/app_colors.dart';
import '../report/report_screen.dart';
import '../home/widgets/location_selector.dart';
import '../home/widgets/active_trip_widget.dart';
import '../core/database/local_database.dart';
import '../core/database/sync_service.dart';
import 'package:uuid/uuid.dart';

class DriverDetailsView extends StatefulWidget {
  final Map<String, dynamic> driverData;
  const DriverDetailsView({super.key, required this.driverData});

  @override
  State<DriverDetailsView> createState() => _DriverDetailsViewState();
}

class _DriverDetailsViewState extends State<DriverDetailsView> {
  final _supabase = Supabase.instance.client;
  final _localTripDb = LocalDatabase();
  final _syncService = SyncService();

  String? _currentUserEmail;
  String? _currentUserId;
  bool _isArrived = false;
  bool _isTripActive = false;
  double _currentFare = 0.0;
  String? _activeTripId;

  @override
  void initState() {
    super.initState();
    _loadAndInitialize();
  }

  Future<void> _loadAndInitialize() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email;
        _currentUserId = user.id;
      });
      await _recordInitialScan();
    }
  }

  Future<void> _recordInitialScan() async {
    final tripId = const Uuid().v4();
    final db = await _localTripDb.database;

    await db.insert('trips', {
      'uuid': tripId,
      'passenger_id': _currentUserId,
      'driver_id': widget.driverData['id']?.toString(),
      'driver_name': widget.driverData['name']?.toString(),
      'driver_plate': widget.driverData['plate']?.toString(),
      'pickup': 'Pending Selection',
      'drop_off': '',
      'fare': 0.0,
      'start_time': DateTime.now().toIso8601String(),
      'is_synced': 0,
    });

    setState(() => _activeTripId = tripId);
    await _syncService.syncOnStart();
  }

  Future<void> _handleTripStarted(Map<String, dynamic> tripData) async {
    if (_activeTripId == null) return;

    final db = await _localTripDb.database;
    await db.update(
      'trips',
      {
        'pickup': tripData['pickup'],
        'drop_off': tripData['dropOff'],
        'fare': tripData['fare'],
        'gas_tier': tripData['gasTier'],
        'is_synced': 0,
      },
      where: 'uuid = ?',
      whereArgs: [_activeTripId],
    );

    setState(() {
      _currentFare = (tripData['fare'] as num).toDouble();
      _isTripActive = true;
    });

    await _syncService.syncOnStart();
  }

  Future<void> _completeTrip() async {
    if (_activeTripId != null) {
      final db = await _localTripDb.database;
      await db.update(
        'trips',
        {'end_time': DateTime.now().toIso8601String(), 'is_synced': 0},
        where: 'uuid = ?',
        whereArgs: [_activeTripId],
      );
      await _syncService.syncOnStart();
    }

    setState(() {
      _isTripActive = false;
      _isArrived = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserEmail == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "RIDE DETAILS",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.darkNavy,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Driver Info UI code remains the same...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  if (!_isArrived && !_isTripActive)
                    LocationSelector(
                      email: _currentUserEmail!,
                      role: "passenger",
                      onFareCalculated: (fare) {},
                      onTripStarted: _handleTripStarted,
                    ),
                  if (_isTripActive)
                    ActiveTripWidget(
                      fare: _currentFare,
                      onArrived: _completeTrip,
                      onCancel: () => setState(() => _isTripActive = false),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
