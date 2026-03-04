import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<_ReportItem> _reports = [
    _ReportItem(
      title: 'Fare dispute',
      subject: 'Driver #D-047',
      status: 'Pending',
      severity: 'Medium',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _ReportItem(
      title: 'Unsafe maneuver',
      subject: 'Driver #D-089',
      status: 'Investigating',
      severity: 'High',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _ReportItem(
      title: 'No mask policy',
      subject: 'Driver #D-131',
      status: 'Resolved',
      severity: 'Low',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _ReportItem(
      title: 'Route refusal',
      subject: 'Driver #D-111',
      status: 'Pending',
      severity: 'High',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  String _activeFilter = 'All';
  String _sortMode = 'Latest';
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReports();
    final pendingCount = _reports.where((r) => r.status == 'Pending').length;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: RefreshIndicator(
        onRefresh: _simulateRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _summaryCard(pendingCount: pendingCount),
            const SizedBox(height: 12),
            _searchField(),
            const SizedBox(height: 10),
            _filterRow(),
            const SizedBox(height: 10),
            _sortRow(),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No reports match your filters.',
                    style: TextStyle(color: Color(0xFF607188)),
                  ),
                ),
              )
            else
              ...filtered.map(_reportTile),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({required int pendingCount}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF17273B), Color(0xFF1E3A5F)],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0x33FFFFFF),
            child: Icon(Icons.report_outlined, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Complaint Center',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            '$pendingCount pending',
            style: const TextStyle(
              color: Color(0xFFB9D7FF),
              fontWeight: FontWeight.w700,
            ),
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
        hintText: 'Search by issue or driver id',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _filterRow() {
    const filters = ['All', 'Pending', 'Investigating', 'Resolved'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((label) {
        final isActive = _activeFilter == label;
        return InkWell(
          onTap: () => setState(() => _activeFilter = label),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF17273B) : const Color(0xFFEFF4FA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF44556C),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sortRow() {
    return Row(
      children: [
        const Text(
          'Sort:',
          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF51647B)),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _sortMode,
          items: const [
            DropdownMenuItem(value: 'Latest', child: Text('Latest')),
            DropdownMenuItem(value: 'Oldest', child: Text('Oldest')),
            DropdownMenuItem(value: 'Severity', child: Text('Severity')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _sortMode = value);
          },
        ),
      ],
    );
  }

  Widget _reportTile(_ReportItem item) {
    final color = switch (item.status) {
      'Pending' => const Color(0xFFB26A00),
      'Investigating' => const Color(0xFF1466B3),
      _ => const Color(0xFF0C7A5A),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE7F4)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.report_problem_outlined, color: Color(0xFF17273B)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.subject} • ${_formatDate(item.timestamp)}',
                      style: const TextStyle(
                        color: Color(0xFF6B7D92),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _smallTag('Severity: ${item.severity}'),
              const Spacer(),
              TextButton(
                onPressed: () => _cycleStatus(item),
                child: const Text('Update Status'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF37506E),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  List<_ReportItem> _filteredReports() {
    final out = _reports.where((item) {
      final statusPass = _activeFilter == 'All' || item.status == _activeFilter;
      final queryPass =
          _query.isEmpty ||
          item.title.toLowerCase().contains(_query) ||
          item.subject.toLowerCase().contains(_query);
      return statusPass && queryPass;
    }).toList();

    switch (_sortMode) {
      case 'Oldest':
        out.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'Severity':
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        out.sort((a, b) => (order[a.severity] ?? 9).compareTo(order[b.severity] ?? 9));
        break;
      default:
        out.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    return out;
  }

  void _cycleStatus(_ReportItem item) {
    setState(() {
      if (item.status == 'Pending') {
        item.status = 'Investigating';
      } else if (item.status == 'Investigating') {
        item.status = 'Resolved';
      } else {
        item.status = 'Pending';
      }
    });
  }

  Future<void> _simulateRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    setState(() {
      _reports.insert(
        0,
        _ReportItem(
          title: 'Overcharging concern',
          subject: 'Driver #D-205',
          status: 'Pending',
          severity: 'Medium',
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _ReportItem {
  _ReportItem({
    required this.title,
    required this.subject,
    required this.status,
    required this.severity,
    required this.timestamp,
  });

  final String title;
  final String subject;
  String status;
  final String severity;
  final DateTime timestamp;
}
