import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<_DriverStatus> _records = [
    _DriverStatus(
      name: 'Driver #D-102',
      location: 'Brgy. Dahican',
      state: 'Online',
      etaMinutes: 4,
    ),
    _DriverStatus(
      name: 'Driver #D-047',
      location: 'City Proper',
      state: 'On Trip',
      etaMinutes: 2,
    ),
    _DriverStatus(
      name: 'Driver #D-089',
      location: 'Mati Port',
      state: 'Idle',
      etaMinutes: 7,
    ),
    _DriverStatus(
      name: 'Driver #D-131',
      location: 'Capitol',
      state: 'On Trip',
      etaMinutes: 3,
    ),
  ];

  String _activeFilter = 'All';
  bool _showFastestFirst = true;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _filteredRecords();
    final onTrip = _records.where((e) => e.state == 'On Trip').length;

    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: RefreshIndicator(
        onRefresh: _simulateLiveUpdate,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _mapPlaceholder(onTrip: onTrip),
            const SizedBox(height: 12),
            _searchField(),
            const SizedBox(height: 10),
            _filterChips(),
            const SizedBox(height: 8),
            _sortToggle(),
            const SizedBox(height: 12),
            if (data.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'No drivers found.',
                    style: TextStyle(color: Color(0xFF607188)),
                  ),
                ),
              )
            else
              ...data.map(_statusTile),
          ],
        ),
      ),
    );
  }

  Widget _mapPlaceholder({required int onTrip}) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C7A5A), Color(0xFF18A0FB)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Map Preview',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pull down to refresh live statuses.',
            style: TextStyle(color: Color(0xFFD4F0FF)),
          ),
          const Spacer(),
          Row(
            children: [
              _badge('On Trip: $onTrip'),
              const SizedBox(width: 8),
              _badge('Tracked: ${_records.length}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
      decoration: InputDecoration(
        hintText: 'Search by driver id or location',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _filterChips() {
    const filters = ['All', 'On Trip', 'Online', 'Idle'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((label) {
        final active = _activeFilter == label;
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => setState(() => _activeFilter = label),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF17273B) : const Color(0xFFEFF4FA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF4A5D74),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sortToggle() {
    return Row(
      children: [
        const Text(
          'Sort by ETA:',
          style: TextStyle(
            color: Color(0xFF51647B),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: Text(_showFastestFirst ? 'Fastest' : 'Slowest'),
          selected: true,
          onSelected: (_) => setState(() => _showFastestFirst = !_showFastestFirst),
        ),
      ],
    );
  }

  Widget _statusTile(_DriverStatus entry) {
    Color chipColor;
    if (entry.state == 'Online') {
      chipColor = const Color(0xFF0C7A5A);
    } else if (entry.state == 'On Trip') {
      chipColor = const Color(0xFF18A0FB);
    } else {
      chipColor = const Color(0xFF8A5CF6);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE7F5)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFEAF3FF),
            child: Icon(Icons.person_outline_rounded, color: Color(0xFF17273B)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  '${entry.location} • ETA ${entry.etaMinutes}m',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667A92),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              entry.state,
              style: TextStyle(color: chipColor, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  List<_DriverStatus> _filteredRecords() {
    final out = _records.where((entry) {
      final filterPass = _activeFilter == 'All' || entry.state == _activeFilter;
      final queryPass =
          _query.isEmpty ||
          entry.name.toLowerCase().contains(_query) ||
          entry.location.toLowerCase().contains(_query);
      return filterPass && queryPass;
    }).toList();

    out.sort((a, b) {
      return _showFastestFirst
          ? a.etaMinutes.compareTo(b.etaMinutes)
          : b.etaMinutes.compareTo(a.etaMinutes);
    });

    return out;
  }

  Future<void> _simulateLiveUpdate() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    setState(() {
      for (final entry in _records) {
        if (entry.state == 'On Trip') {
          entry.etaMinutes = entry.etaMinutes > 1 ? entry.etaMinutes - 1 : 1;
        } else if (entry.state == 'Online') {
          entry.etaMinutes = entry.etaMinutes + 1;
        }
      }
      _records.add(
        _DriverStatus(
          name: 'Driver #D-23${_records.length}',
          location: 'Rotonda',
          state: 'Online',
          etaMinutes: 5,
        ),
      );
    });
  }
}

class _DriverStatus {
  _DriverStatus({
    required this.name,
    required this.location,
    required this.state,
    required this.etaMinutes,
  });

  final String name;
  final String location;
  final String state;
  int etaMinutes;
}
