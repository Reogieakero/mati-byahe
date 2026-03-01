import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constant/app_colors.dart';
import '../core/database/local_database.dart';
import '../core/services/trip_service.dart';

class DriverTripHistoryScreen extends StatefulWidget {
  const DriverTripHistoryScreen({super.key});

  @override
  State<DriverTripHistoryScreen> createState() =>
      _DriverTripHistoryScreenState();
}

class _DriverTripHistoryScreenState extends State<DriverTripHistoryScreen> {
  final TripService _tripService = TripService();
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String _selectedGasTier = 'All';
  bool _sortNewest = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadTrips() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final db = await _localDb.database;
    return db.query(
      'trips',
      where: 'driver_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  Future<void> _refresh() async {
    await _tripService.syncTrips();
    if (mounted) setState(() {});
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> trips) {
    var filtered = trips.where((trip) {
      final pickup = (trip['pickup'] as String? ?? '').toLowerCase();
      final dropOff = (trip['drop_off'] as String? ?? '').toLowerCase();
      final gasTier = (trip['gas_tier'] as String? ?? 'N/A');
      final query = _query.toLowerCase();

      final matchesQuery =
          query.isEmpty || pickup.contains(query) || dropOff.contains(query);
      final matchesGasTier =
          _selectedGasTier == 'All' || gasTier == _selectedGasTier;
      return matchesQuery && matchesGasTier;
    }).toList();

    filtered.sort((a, b) {
      final da =
          DateTime.tryParse((a['date'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final db =
          DateTime.tryParse((b['date'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return _sortNewest ? db.compareTo(da) : da.compareTo(db);
    });
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          'TRIP HISTORY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkNavy,
        elevation: 0.5,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          final allTrips = snapshot.data ?? [];
          final gasTiers = {
            'All',
            ...allTrips.map((e) => (e['gas_tier'] as String?) ?? 'N/A'),
          }.toList();
          final trips = _applyFilters(allTrips);

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 14, 15, 20),
              children: [
                _buildSummary(trips),
                const SizedBox(height: 12),
                _buildControls(gasTiers),
                const SizedBox(height: 12),
                if (trips.isEmpty)
                  _buildEmptyState()
                else
                  ..._buildTripCards(trips),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummary(List<Map<String, dynamic>> trips) {
    final totalTrips = trips.length;
    final totalEarnings = trips.fold<double>(
      0.0,
      (sum, trip) => sum + ((trip['fare'] as num?)?.toDouble() ?? 0.0),
    );
    final avgFare = totalTrips == 0 ? 0.0 : totalEarnings / totalTrips;

    return Row(
      children: [
        Expanded(
          child: _summaryCard('Trips', '$totalTrips', Icons.route_rounded),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _summaryCard(
            'Earnings',
            '₱${totalEarnings.toStringAsFixed(0)}',
            Icons.payments_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _summaryCard(
            'Avg Fare',
            '₱${avgFare.toStringAsFixed(0)}',
            Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryBlue),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.darkNavy,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textGrey.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(List<String> gasTiers) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search pickup or destination...',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: gasTiers
                      .map(
                        (tier) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(tier),
                            selected: _selectedGasTier == tier,
                            selectedColor: AppColors.primaryBlue.withValues(
                              alpha: 0.14,
                            ),
                            onSelected: (_) =>
                                setState(() => _selectedGasTier = tier),
                            labelStyle: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _selectedGasTier == tier
                                  ? AppColors.primaryBlue
                                  : AppColors.darkNavy,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            IconButton(
              tooltip: _sortNewest ? 'Sort oldest first' : 'Sort newest first',
              onPressed: () => setState(() => _sortNewest = !_sortNewest),
              icon: Icon(
                _sortNewest ? Icons.south_rounded : Icons.north_rounded,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: const [
        SizedBox(height: 60),
        Icon(Icons.route_rounded, size: 64, color: AppColors.textGrey),
        SizedBox(height: 12),
        Text(
          'No trips match your filters.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTripCards(List<Map<String, dynamic>> trips) {
    return trips
        .map(
          (trip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TripCard(trip: trip),
          ),
        )
        .toList();
  }
}

class _TripCard extends StatelessWidget {
  final Map<String, dynamic> trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final fare = (trip['fare'] as num?)?.toDouble() ?? 0.0;
    final pickup = (trip['pickup'] as String?) ?? 'Unknown pickup';
    final dropOff = (trip['drop_off'] as String?) ?? 'Unknown drop-off';
    final gasTier = (trip['gas_tier'] as String?) ?? 'N/A';
    final dateRaw = DateTime.tryParse((trip['date'] as String?) ?? '');
    final dateText = dateRaw == null
        ? 'Date unavailable'
        : '${dateRaw.year}-${dateRaw.month.toString().padLeft(2, '0')}-${dateRaw.day.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.directions_car_rounded,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$pickup → $dropOff',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₱${fare.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip(Icons.calendar_today_rounded, dateText),
              const SizedBox(width: 6),
              _chip(Icons.local_gas_station_rounded, gasTier),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primaryBlue),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.darkNavy,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
