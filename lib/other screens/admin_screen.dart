import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../core/constant/app_colors.dart';

/// A simple administrative dashboard screen for the Mati Byahe app.
/// Uses the same colour palette and gradient background as HomeScreen.
class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome, Admin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Manage the application settings and review reports below.',
                    style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 24),
                  _buildDashboard(context),
                  const SizedBox(height: 16),
                  _buildActionGrid(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    final actions = <_AdminAction>[
      _AdminAction('Users', Icons.person, AppColors.primaryBlue),
      _AdminAction('Rides', Icons.directions_car, AppColors.primaryYellow),
      _AdminAction('Fares', Icons.local_taxi, AppColors.primaryBlue),
      _AdminAction('Payments', Icons.payment, AppColors.primaryYellow),
      _AdminAction('Reports', Icons.report, AppColors.primaryBlue),
      _AdminAction('Settings', Icons.settings, AppColors.primaryYellow),
    ];

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: actions
          .map(
            (a) => GestureDetector(
              onTap: () {
                switch (a.label) {
                  case 'Users':
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const _UsersScreen()),
                    );
                    break;
                  case 'Rides':
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const _RidesScreen()),
                    );
                    break;
                  case 'Fares':
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const _FaresScreen()),
                    );
                    break;
                  case 'Payments':
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const _PaymentsScreen(),
                      ),
                    );
                    break;
                  case 'Reports':
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const _ReportsScreen()),
                    );
                    break;
                  case 'Settings':
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _SettingsScreen(
                          userRole:
                              'Super Admin', // adjust based on real user role
                        ),
                      ),
                    );
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: a.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: a.color.withOpacity(0.18),
                      child: Icon(a.icon, color: a.color),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      a.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Key Metrics Grid
        Row(
          children: [
            Flexible(
              child: _StatCard(
                label: 'Total Drivers',
                value: '45',
                color: AppColors.primaryBlue,
                icon: Icons.people,
                trend: '+5 this month',
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: _StatCard(
                label: 'Active Riders',
                value: '128',
                color: AppColors.primaryYellow,
                icon: Icons.person,
                trend: '+12 today',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Flexible(
              child: _StatCard(
                label: 'Rides Today',
                value: '38',
                color: Colors.teal,
                icon: Icons.directions_car,
                trend: 'avg: ₱450',
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: _StatCard(
                label: 'Pending Reviews',
                value: '7',
                color: Colors.deepOrange,
                icon: Icons.pending_actions,
                trend: '3 urgent',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // System Status Overview
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Status',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusIndicator('Platform', 'Online', Colors.green),
                  _buildStatusIndicator('API', 'Healthy', Colors.green),
                  _buildStatusIndicator('Database', 'Connected', Colors.green),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Recent Activity
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(
              4,
              (i) => Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 8 : 0,
                  bottom: i == 3 ? 8 : 0,
                  left: 12,
                  right: 12,
                ),
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: [
                          AppColors.primaryBlue.withOpacity(0.15),
                          AppColors.primaryYellow.withOpacity(0.15),
                          Colors.green.withOpacity(0.15),
                          Colors.red.withOpacity(0.15),
                        ][i],
                        child: Icon(
                          [
                            Icons.person_add,
                            Icons.directions_car,
                            Icons.check_circle,
                            Icons.warning,
                          ][i],
                          color: [
                            AppColors.primaryBlue,
                            AppColors.primaryYellow,
                            Colors.green,
                            Colors.red,
                          ][i],
                          size: 20,
                        ),
                      ),
                      title: Text(
                        [
                          'New driver application submitted',
                          'Ride completed successfully',
                          'Payment received',
                          'System alert: Low funds',
                        ][i],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat.jm().format(
                          DateTime.now().subtract(
                            Duration(minutes: [5, 15, 25, 45][i]),
                          ),
                        ),
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: Text(
                        ['Pending', 'Completed', 'Success', 'Alert'][i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: [
                            Colors.orange,
                            Colors.green,
                            Colors.green,
                            Colors.red,
                          ][i],
                        ),
                      ),
                    ),
                    if (i < 3)
                      Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, String status, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 6),
            Text(
              status,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
    this.trend,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;
  final String? trend;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (icon != null)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
              ],
            ),
            if (trend != null) ...[
              const SizedBox(height: 8),
              Text(
                trend!,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdminAction {
  final String label;
  final IconData icon;
  final Color color;
  _AdminAction(this.label, this.icon, this.color);
}

// ------------------- internal screens -------------------

class _UsersScreen extends StatefulWidget {
  const _UsersScreen({Key? key}) : super(key: key);

  @override
  State<_UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<_UsersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Driver data with management features
  final List<Map<String, dynamic>> _drivers = [
    {
      'name': 'Juan Dela Cruz',
      'email': 'juan@example.com',
      'status': 'Approved',
      'vehicle': 'Motorcycle',
      'rating': 4.8,
      'rides': 234,
      'earnings': '₱45,320',
      'documents': {
        'license': 'verified',
        'or_cr': 'verified',
        'nbi': 'verified',
      },
      'area': 'Mati City - All Barangays',
    },
    {
      'name': 'Maria Santos',
      'email': 'maria@example.com',
      'status': 'Pending Review',
      'vehicle': 'Tricycle',
      'rating': 0.0,
      'rides': 0,
      'earnings': '₱0',
      'documents': {'license': 'pending', 'or_cr': 'pending', 'nbi': 'pending'},
      'area': 'Not Assigned',
    },
  ];

  // Passenger data
  final List<Map<String, dynamic>> _passengers = [
    {
      'name': 'Alice Johnson',
      'email': 'alice@example.com',
      'status': 'Verified',
      'rides': 45,
      'complaints': 0,
    },
    {
      'name': 'Bob Martinez',
      'email': 'bob@example.com',
      'status': 'Unverified',
      'rides': 12,
      'complaints': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showDriverDetails(Map<String, dynamic> driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver['name'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          driver['vehicle'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (driver['status'] as String) == 'Approved'
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        driver['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (driver['status'] as String) == 'Approved'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Performance Metrics',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetric('Rating', '${driver['rating']}'),
                          _buildMetric('Rides', '${driver['rides']}'),
                          _buildMetric(
                            'Earnings',
                            driver['earnings'] as String,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Service Area: ${driver['area']}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Documents',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ..._buildDocumentsList(driver['documents'] as Map),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              (driver['status'] as String) == 'Approved'
                              ? Colors.red
                              : Colors.green,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            if (driver['status'] == 'Approved') {
                              driver['status'] = 'Suspended';
                            } else {
                              driver['status'] = 'Approved';
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                (driver['status'] as String) == 'Approved'
                                    ? 'Driver approved'
                                    : 'Driver suspended',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          (driver['status'] as String) == 'Approved'
                              ? 'Suspend'
                              : 'Approve',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDocumentsList(Map docs) {
    return [
      _buildDocumentItem('Driver\'s License', docs['license'] as String),
      _buildDocumentItem('OR/CR', docs['or_cr'] as String),
      _buildDocumentItem('NBI Clearance', docs['nbi'] as String),
    ];
  }

  Widget _buildDocumentItem(String label, String status) {
    final isVerified = status == 'verified';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isVerified
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isVerified ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  void _showPassengerDetails(Map<String, dynamic> passenger) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              passenger['name'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${passenger['email']}',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            const Text('Account Status'),
            const SizedBox(height: 4),
            Chip(
              label: Text(passenger['status'] as String),
              backgroundColor: (passenger['status'] as String) == 'Verified'
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric('Rides', '${passenger['rides']}'),
                _buildMetric('Complaints', '${passenger['complaints']}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        passenger['status'] = 'Suspended';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passenger suspended')),
                      );
                    },
                    child: const Text(
                      'Suspend',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.primaryYellow,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Drivers'),
            Tab(text: 'Passengers'),
          ],
        ),
      ),
      body: Container(
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
        child: TabBarView(
          controller: _tabController,
          children: [_buildDriversTab(), _buildPassengersTab()],
        ),
      ),
    );
  }

  Widget _buildDriversTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search drivers',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _drivers.isEmpty
                ? const Center(child: Text('No drivers found'))
                : ListView.separated(
                    itemCount: _drivers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final driver = _drivers[i];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryBlue.withOpacity(
                              0.2,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          title: Text(
                            driver['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(driver['vehicle'] as String),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (driver['status'] as String) == 'Approved'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              driver['status'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                    (driver['status'] as String) == 'Approved'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                          onTap: () => _showDriverDetails(driver),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengersTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search passengers',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _passengers.isEmpty
                ? const Center(child: Text('No passengers found'))
                : ListView.separated(
                    itemCount: _passengers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final passenger = _passengers[i];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryYellow
                                .withOpacity(0.2),
                            child: const Icon(
                              Icons.person_outline,
                              color: AppColors.primaryYellow,
                            ),
                          ),
                          title: Text(
                            passenger['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'Rides: ${passenger['rides']} | Complaints: ${passenger['complaints']}',
                          ),
                          trailing: Chip(
                            label: Text(passenger['status'] as String),
                            backgroundColor:
                                (passenger['status'] as String) == 'Verified'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                          ),
                          onTap: () => _showPassengerDetails(passenger),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _RidesScreen extends StatefulWidget {
  const _RidesScreen({Key? key}) : super(key: key);

  @override
  State<_RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<_RidesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _filterController = TextEditingController();

  // Mock ride data
  final List<Map<String, dynamic>> _rides = [
    {
      'id': 'RIDE001',
      'passenger': 'John Doe',
      'driver': 'Juan Dela Cruz',
      'status': 'Ongoing',
      'pickup': 'Mati City Hall',
      'dropoff': 'Mati Hospital',
      'distance': '5.2 km',
      'fare': '₱185.50',
      'basefare': '₱40',
      'kmrate': '₱25/km',
      'timecharge': '₱2/min',
      'eta': '12 mins',
    },
    {
      'id': 'RIDE002',
      'passenger': 'Maria Santos',
      'driver': 'Unassigned',
      'status': 'Pending',
      'pickup': 'Mati Public Market',
      'dropoff': 'Barangay Dahican',
      'distance': '3.8 km',
      'fare': '₱140.00',
      'basefare': '₱40',
      'kmrate': '₱25/km',
      'timecharge': '₱2/min',
      'eta': 'Waiting for driver',
    },
    {
      'id': 'RIDE003',
      'passenger': 'Alice Johnson',
      'driver': 'Maria Santos',
      'status': 'Completed',
      'pickup': 'City Center',
      'dropoff': 'Barangay Suaco',
      'distance': '4.5 km',
      'fare': '₱162.50',
      'basefare': '₱40',
      'kmrate': '₱25/km',
      'timecharge': '₱2/min',
      'eta': 'Completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredByStatus {
    final status = [
      'All',
      'Pending',
      'Accepted',
      'Ongoing',
      'Completed',
    ][_tabController.index];

    if (status == 'All') return _rides;
    return _rides.where((r) => (r['status'] as String) == status).toList();
  }

  void _showRideDetails(Map<String, dynamic> ride) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ride ${ride['id']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Passenger: ${ride['passenger']}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          ride['status'] as String,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ride['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(ride['status'] as String),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Route Information
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Route',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryBlue,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pickup',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  ride['pickup'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        height: 1,
                        color: AppColors.primaryBlue.withOpacity(0.2),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryYellow,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Drop-off',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  ride['dropoff'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Fare Breakdown
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fare Breakdown',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildFareRow('Base Fare', ride['basefare'] as String),
                      _buildFareRow(
                        'Distance (${ride['distance']})',
                        ride['kmrate'] as String,
                      ),
                      _buildFareRow(
                        'Time Charge',
                        ride['timecharge'] as String,
                      ),
                      Divider(height: 12, color: Colors.grey.withOpacity(0.2)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            ride['fare'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Driver Information
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Driver',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ride['driver'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if ((ride['status'] as String) != 'Completed') ...[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text('Reassign Driver'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Driver reassignment initiated'),
                              ),
                            );
                          },
                        ),
                      ] else
                        const Text(
                          'Ride completed',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFareRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.blue;
      case 'Ongoing':
        return Colors.purple;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rides Management'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.primaryYellow,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Container(
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
        child: TabBarView(
          controller: _tabController,
          children: List.generate(5, (_) => _buildRidesTab()),
        ),
      ),
    );
  }

  Widget _buildRidesTab() {
    final filtered = _filteredByStatus;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: filtered.isEmpty
          ? const Center(child: Text('No rides found for this status'))
          : ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final ride = filtered[i];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(
                        ride['status'] as String,
                      ).withOpacity(0.2),
                      child: Icon(
                        Icons.directions_car,
                        color: _getStatusColor(ride['status'] as String),
                      ),
                    ),
                    title: Text(
                      'Ride ${ride['id']}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${ride['pickup']} → ${ride['dropoff']}',
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Driver: ${ride['driver']} | ${ride['fare']}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          ride['status'] as String,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ride['status'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(ride['status'] as String),
                        ),
                      ),
                    ),
                    onTap: () => _showRideDetails(ride),
                  ),
                );
              },
            ),
    );
  }
}

class _PaymentsScreen extends StatefulWidget {
  const _PaymentsScreen({Key? key}) : super(key: key);

  @override
  State<_PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<_PaymentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Commission percentage
  double _commissionPercentage = 15.0;
  final TextEditingController _commissionController = TextEditingController(
    text: '15.0',
  );

  // Revenue data
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN001',
      'rideId': 'RIDE001',
      'passenger': 'John Doe',
      'driver': 'Juan Dela Cruz',
      'amount': 185.50,
      'method': 'Cash',
      'status': 'Completed',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'platformFee': 27.83,
      'driverEarnings': 157.67,
    },
    {
      'id': 'TXN002',
      'rideId': 'RIDE002',
      'passenger': 'Maria Santos',
      'driver': 'Maria Santos',
      'amount': 140.00,
      'method': 'GCash',
      'status': 'Completed',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'platformFee': 21.00,
      'driverEarnings': 119.00,
    },
    {
      'id': 'TXN003',
      'rideId': 'RIDE003',
      'passenger': 'Alice Johnson',
      'driver': 'Maria Santos',
      'amount': 162.50,
      'method': 'GCash',
      'status': 'Completed',
      'date': DateTime.now().subtract(const Duration(hours: 12)),
      'platformFee': 24.38,
      'driverEarnings': 138.13,
    },
  ];

  // Payout tracking
  final List<Map<String, dynamic>> _payouts = [
    {
      'driver': 'Juan Dela Cruz',
      'email': 'juan@example.com',
      'totalEarnings': 2847.50,
      'totalPaidOut': 2100.00,
      'totalPending': 747.50,
      'method': 'Cash',
      'lastPayout': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'driver': 'Maria Santos',
      'email': 'maria@example.com',
      'totalEarnings': 1560.00,
      'totalPaidOut': 1200.00,
      'totalPending': 360.00,
      'method': 'GCash',
      'lastPayout': DateTime.now().subtract(const Duration(days: 7)),
    },
  ];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  double get _totalRevenue =>
      _transactions.fold(0, (sum, t) => sum + (t['platformFee'] as double));

  double get _totalDriverEarnings =>
      _transactions.fold(0, (sum, t) => sum + (t['driverEarnings'] as double));

  void _saveCommission() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isSaving = false;
        _commissionPercentage = double.parse(_commissionController.text);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Commission rate updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Revenue report generated and exported'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _processPayouts() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Process Payouts'),
        content: const Text(
          'Issue payouts to all drivers with pending balance?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payouts processed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Process'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Management'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.primaryYellow,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Transactions'),
            Tab(text: 'Payouts'),
            Tab(text: 'Commission'),
          ],
        ),
      ),
      body: Container(
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildTransactionsTab(),
            _buildPayoutsTab(),
            _buildCommissionTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Cards
            Row(
              children: [
                Flexible(
                  child: _buildStatCard(
                    'Total Revenue',
                    '₱${_totalRevenue.toStringAsFixed(2)}',
                    AppColors.primaryBlue,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: _buildStatCard(
                    'Driver Payouts',
                    '₱${_totalDriverEarnings.toStringAsFixed(2)}',
                    Colors.green,
                    Icons.payments,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  child: _buildStatCard(
                    'Total Transactions',
                    '${_transactions.length}',
                    AppColors.primaryYellow,
                    Icons.receipt,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: _buildStatCard(
                    'Commission Rate',
                    '${_commissionPercentage.toStringAsFixed(1)}%',
                    Colors.purple,
                    Icons.percent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Payment Methods Statistics
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentMethodCard(
                    'Cash',
                    Icons.money,
                    Colors.green,
                    _transactions.where((t) => t['method'] == 'Cash').length,
                    _transactions
                        .where((t) => t['method'] == 'Cash')
                        .fold<double>(
                          0,
                          (sum, t) => sum + (t['amount'] as double),
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentMethodCard(
                    'GCash',
                    Icons.mobile_screen_share,
                    Colors.blue,
                    _transactions.where((t) => t['method'] == 'GCash').length,
                    _transactions
                        .where((t) => t['method'] == 'GCash')
                        .fold<double>(
                          0,
                          (sum, t) => sum + (t['amount'] as double),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Quick Actions
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.description),
                label: const Text('Generate Revenue Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _generateReport,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.money_off),
                label: const Text('Process Payouts'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _processPayouts,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final txn = _transactions[i];
          return Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: (txn['method'] as String) == 'Cash'
                    ? Colors.green.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                child: Icon(
                  (txn['method'] as String) == 'Cash'
                      ? Icons.money
                      : Icons.mobile_screen_share,
                  color: (txn['method'] as String) == 'Cash'
                      ? Colors.green
                      : Colors.blue,
                ),
              ),
              title: Text(
                'Transaction ${txn['id']}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    '${txn['passenger']} → ${txn['driver']}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat(
                      'MMM dd, yyyy - hh:mm a',
                    ).format(txn['date'] as DateTime),
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '₱${(txn['amount'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    txn['method'] as String,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
              onTap: () => _showTransactionDetails(txn),
            ),
          );
        },
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> txn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction ${txn['id']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ride: ${txn['rideId']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transaction Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Passenger', txn['passenger'] as String),
                      _buildDetailRow('Driver', txn['driver'] as String),
                      _buildDetailRow(
                        'Payment Method',
                        txn['method'] as String,
                      ),
                      _buildDetailRow(
                        'Date & Time',
                        DateFormat(
                          'MMM dd, yyyy - hh:mm a',
                        ).format(txn['date'] as DateTime),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fare Breakdown',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ride Amount',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '₱${(txn['amount'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Platform Fee (15%)',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '₱${(txn['platformFee'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Driver Earning',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '₱${(txn['driverEarnings'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _payouts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final payout = _payouts[i];
          return Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primaryBlue,
                ),
              ),
              title: Text(
                payout['driver'] as String,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Pending: ₱${(payout['totalPending'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${payout['method']} • Last: ${DateFormat('MMM dd').format(payout['lastPayout'] as DateTime)}',
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Payout processed for ${payout['driver']}',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Pay',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
              onTap: () => _showPayoutDetails(payout),
            ),
          );
        },
      ),
    );
  }

  void _showPayoutDetails(Map<String, dynamic> payout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payout['driver'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          payout['email'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        payout['method'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Earnings Summary',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Total Earnings',
                        '₱${(payout['totalEarnings'] as double).toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Total Paid Out',
                        '₱${(payout['totalPaidOut'] as double).toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Pending Balance',
                        '₱${(payout['totalPending'] as double).toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Last Payout',
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(payout['lastPayout'] as DateTime),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Payout ₱${(payout['totalPending'] as double).toStringAsFixed(2)} processed for ${payout['driver']}',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text(
                          'Pay Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommissionTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Commission Management',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Platform Commission Percentage',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Set the percentage of each ride fare that goes to the platform',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _commissionController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: '%',
                      hintText: 'Enter commission percentage',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Commission Preview
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Commission Preview (₱100 Ride)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Ride Fare', '₱100.00'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Platform Commission (${_commissionPercentage.toStringAsFixed(1)}%)',
                    '₱${(100 * _commissionPercentage / 100).toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Driver Earning',
                    '₱${(100 - (100 * _commissionPercentage / 100)).toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Historical Commission Data
            const Text(
              'Commission Statistics',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    'Total Platform Revenue',
                    '₱${_totalRevenue.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Total Driver Payouts',
                    '₱${_totalDriverEarnings.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Commission Rate Applied',
                    '${_commissionPercentage.toStringAsFixed(1)}%',
                  ),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Total Transactions',
                    '${_transactions.length}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isSaving ? 'Saving...' : 'Save Commission Rate',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isSaving ? null : _saveCommission,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    String method,
    IconData icon,
    Color color,
    int count,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  method,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDetailRow('Transactions', count.toString()),
          const SizedBox(height: 6),
          _buildDetailRow('Total', '₱${total.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}

class _FaresScreen extends StatefulWidget {
  const _FaresScreen({Key? key}) : super(key: key);

  @override
  State<_FaresScreen> createState() => _FaresScreenState();
}

class _FaresScreenState extends State<_FaresScreen> {
  // Base fare configuration
  final TextEditingController _baseFareController = TextEditingController(
    text: '40.00',
  );
  final TextEditingController _perKmController = TextEditingController(
    text: '25.00',
  );
  final TextEditingController _perMinController = TextEditingController(
    text: '2.00',
  );
  final TextEditingController _minFareController = TextEditingController(
    text: '50.00',
  );
  final TextEditingController _cancellationFeeController =
      TextEditingController(text: '15.00');

  // Surge pricing
  bool _enableRushHourSurge = true;
  bool _enableRainSurge = true;
  bool _enableEventSurge = true;

  final TextEditingController _rushHourMultiplierController =
      TextEditingController(text: '1.5');
  final TextEditingController _rainMultiplierController = TextEditingController(
    text: '1.3',
  );
  final TextEditingController _eventMultiplierController =
      TextEditingController(text: '1.2');

  final TextEditingController _rushHourStartController = TextEditingController(
    text: '07:00 AM',
  );
  final TextEditingController _rushHourEndController = TextEditingController(
    text: '10:00 AM',
  );

  bool _isSaving = false;

  @override
  void dispose() {
    _baseFareController.dispose();
    _perKmController.dispose();
    _perMinController.dispose();
    _minFareController.dispose();
    _cancellationFeeController.dispose();
    _rushHourMultiplierController.dispose();
    _rainMultiplierController.dispose();
    _eventMultiplierController.dispose();
    _rushHourStartController.dispose();
    _rushHourEndController.dispose();
    super.dispose();
  }

  void _saveConfiguration() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fare configuration saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fare Management'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
      body: Container(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Base Fare Section
                _buildSectionHeader('Base Fare Configuration'),
                const SizedBox(height: 12),
                _buildFareInputField(
                  'Base Fare (₱)',
                  _baseFareController,
                  'Minimum charge for any ride',
                ),
                const SizedBox(height: 12),
                _buildFareInputField(
                  'Per Kilometer Rate (₱/km)',
                  _perKmController,
                  'Charge per kilometer traveled',
                ),
                const SizedBox(height: 12),
                _buildFareInputField(
                  'Per Minute Rate (₱/min)',
                  _perMinController,
                  'Charge per minute of ride duration',
                ),
                const SizedBox(height: 12),
                _buildFareInputField(
                  'Minimum Fare (₱)',
                  _minFareController,
                  'Lowest total fare for any ride',
                ),
                const SizedBox(height: 12),
                _buildFareInputField(
                  'Cancellation Fee (₱)',
                  _cancellationFeeController,
                  'Fee charged when passenger cancels',
                ),
                const SizedBox(height: 24),

                // Surge Pricing Section
                _buildSectionHeader('Surge Pricing Configuration'),
                const SizedBox(height: 12),

                // Rush Hour Surge
                _buildSurgeCard(
                  enabled: _enableRushHourSurge,
                  title: 'Rush Hour Surge',
                  description: 'Apply surge multiplier during peak hours',
                  icon: Icons.schedule,
                  iconColor: AppColors.primaryBlue,
                  onToggle: (v) => setState(() => _enableRushHourSurge = v),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallInputField(
                              _rushHourStartController,
                              'Start Time',
                              Icons.access_time,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSmallInputField(
                              _rushHourEndController,
                              'End Time',
                              Icons.access_time,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSmallInputField(
                        _rushHourMultiplierController,
                        'Multiplier (e.g., 1.5x)',
                        Icons.trending_up,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Rain Surge
                _buildSurgeCard(
                  enabled: _enableRainSurge,
                  title: 'Rain Surge',
                  description: 'Apply surge multiplier during rainfall',
                  icon: Icons.cloud_queue,
                  iconColor: Colors.lightBlue,
                  onToggle: (v) => setState(() => _enableRainSurge = v),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildSmallInputField(
                        _rainMultiplierController,
                        'Multiplier (e.g., 1.3x)',
                        Icons.trending_up,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Event Surge
                _buildSurgeCard(
                  enabled: _enableEventSurge,
                  title: 'Event Surge',
                  description: 'Apply surge multiplier during special events',
                  icon: Icons.celebration,
                  iconColor: AppColors.primaryYellow,
                  onToggle: (v) => setState(() => _enableEventSurge = v),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildSmallInputField(
                        _eventMultiplierController,
                        'Multiplier (e.g., 1.2x)',
                        Icons.trending_up,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Fare Calculation Formula',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Total Fare = max(Base Fare + (Distance × Per KM Rate) + (Duration × Per Min Rate), Minimum Fare)',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Final Fare = Total Fare × Applicable Surge Multiplier',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isSaving ? 'Saving...' : 'Save Configuration',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isSaving ? null : _saveConfiguration,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.darkNavy,
      ),
    );
  }

  Widget _buildFareInputField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.darkNavy,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12, color: Colors.black38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInputField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          ),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSurgeCard({
    required bool enabled,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Function(bool) onToggle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: enabled
              ? AppColors.primaryBlue.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                onChanged: onToggle,
                activeColor: AppColors.primaryBlue,
              ),
            ],
          ),
          if (enabled) child,
        ],
      ),
    );
  }
}

class _ReportsScreen extends StatefulWidget {
  const _ReportsScreen({Key? key}) : super(key: key);

  @override
  State<_ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<_ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Complaints data
  final List<Map<String, dynamic>> _complaints = [
    {
      'id': 'CMP001',
      'type': 'Driver',
      'complainant': 'Alice Johnson',
      'subject': 'Driver was rude',
      'description':
          'The driver was very impatient and rude during the journey.',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'status': 'Open',
      'severity': 'High',
      'rideId': 'RIDE001',
    },
    {
      'id': 'CMP002',
      'type': 'Passenger',
      'complainant': 'Juan Dela Cruz',
      'subject': 'Passenger not found',
      'description': 'Passenger did not show up at pickup location.',
      'date': DateTime.now().subtract(const Duration(hours: 12)),
      'status': 'Resolved',
      'severity': 'Medium',
      'rideId': 'RIDE002',
    },
    {
      'id': 'CMP003',
      'type': 'Driver',
      'complainant': 'Maria Santos',
      'subject': 'Incorrect route taken',
      'description': 'Driver took a longer route to increase fare.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Under Investigation',
      'severity': 'High',
      'rideId': 'RIDE003',
    },
  ];

  // Chat logs data
  final List<Map<String, dynamic>> _chatLogs = [
    {
      'id': 'CHAT001',
      'rideId': 'RIDE001',
      'passenger': 'John Doe',
      'driver': 'Juan Dela Cruz',
      'messages': 5,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'Completed',
      'preview': 'Driver: I am near your location...',
    },
    {
      'id': 'CHAT002',
      'rideId': 'RIDE004',
      'passenger': 'Sarah Wilson',
      'driver': 'Maria Santos',
      'messages': 3,
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'Completed',
      'preview': 'Passenger: Can you wait 2 minutes?',
    },
    {
      'id': 'CHAT003',
      'rideId': 'RIDE005',
      'passenger': 'Mike Chen',
      'driver': 'Lito Garcia',
      'messages': 8,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Archived',
      'preview': 'Driver: Wrong address, please confirm...',
    },
  ];

  // Incident logs data
  final List<Map<String, dynamic>> _incidentLogs = [
    {
      'id': 'INC001',
      'type': 'Safety Incident',
      'description': 'Driver used excessive speed',
      'involvedParties': 'Driver: Juan Dela Cruz, Passenger: Alice',
      'date': DateTime.now().subtract(const Duration(hours: 4)),
      'status': 'Logged',
      'severity': 'Critical',
      'actionTaken': 'Warning issued to driver',
    },
    {
      'id': 'INC002',
      'type': 'Vehicle Issue',
      'description': 'Vehicle was dirty/unclean',
      'involvedParties': 'Driver: Maria Santos',
      'date': DateTime.now().subtract(const Duration(hours: 8)),
      'status': 'Resolved',
      'severity': 'Low',
      'actionTaken': 'Driver instructed to maintain vehicle',
    },
    {
      'id': 'INC003',
      'type': 'Policy Violation',
      'description': 'Driver consumed alcohol during shift',
      'involvedParties': 'Driver: Unknown',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'Logged',
      'severity': 'Critical',
      'actionTaken': 'Account suspended pending investigation',
    },
  ];

  // SOS alerts data
  final List<Map<String, dynamic>> _sosAlerts = [
    {
      'id': 'SOS001',
      'passengerId': 'P001',
      'passenger': 'Maria Santos',
      'rideId': 'RIDE006',
      'driver': 'Juan Dela Cruz',
      'location': 'Mati City Hall',
      'date': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'Resolved',
      'severity': 'High',
      'description': 'Passenger felt unsafe during ride',
      'responseTime': '3 mins',
    },
    {
      'id': 'SOS002',
      'passengerId': 'P002',
      'passenger': 'Alice Johnson',
      'rideId': 'RIDE007',
      'driver': 'Maria Santos',
      'location': 'Downtown Area',
      'date': DateTime.now().subtract(const Duration(hours: 6)),
      'status': 'Resolved',
      'severity': 'Medium',
      'description': 'Call not connecting - system issue',
      'responseTime': '2 mins',
    },
    {
      'id': 'SOS003',
      'passengerId': 'P003',
      'passenger': 'John Doe',
      'rideId': 'RIDE008',
      'driver': 'Lito Garcia',
      'location': 'Emergency Zone',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Escalated',
      'severity': 'Critical',
      'description': 'Medical emergency during ride',
      'responseTime': '1 min',
    },
  ];

  String _complaintFilter = 'All';
  String _incidentStatusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredComplaints {
    if (_complaintFilter == 'All') return _complaints;
    return _complaints
        .where((c) => (c['status'] as String) == _complaintFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Incidents'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.primaryYellow,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Complaints'),
            Tab(text: 'Chat Logs'),
            Tab(text: 'Incidents'),
            Tab(text: 'SOS Alerts'),
          ],
        ),
      ),
      body: Container(
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildComplaintsTab(),
            _buildChatLogsTab(),
            _buildIncidentsTab(),
            _buildSOSAlertsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _complaintFilter == 'All',
                  onSelected: (_) => setState(() => _complaintFilter = 'All'),
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Open'),
                  selected: _complaintFilter == 'Open',
                  onSelected: (_) => setState(() => _complaintFilter = 'Open'),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.orange.withOpacity(0.2),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Under Investigation'),
                  selected: _complaintFilter == 'Under Investigation',
                  onSelected: (_) =>
                      setState(() => _complaintFilter = 'Under Investigation'),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.blue.withOpacity(0.2),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Resolved'),
                  selected: _complaintFilter == 'Resolved',
                  onSelected: (_) =>
                      setState(() => _complaintFilter = 'Resolved'),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.green.withOpacity(0.2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredComplaints.isEmpty
                ? const Center(child: Text('No complaints found'))
                : ListView.separated(
                    itemCount: _filteredComplaints.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final complaint = _filteredComplaints[i];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: _getSeverityColor(
                              complaint['severity'] as String,
                            ).withOpacity(0.2),
                            child: Icon(
                              complaint['type'] == 'Driver'
                                  ? Icons.person_outline
                                  : Icons.directions_car,
                              color: _getSeverityColor(
                                complaint['severity'] as String,
                              ),
                            ),
                          ),
                          title: Text(
                            complaint['subject'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'By: ${complaint['complainant']} (${complaint['type']})',
                                style: const TextStyle(fontSize: 11),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy - hh:mm a',
                                ).format(complaint['date'] as DateTime),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                complaint['status'] as String,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              complaint['status'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(
                                  complaint['status'] as String,
                                ),
                              ),
                            ),
                          ),
                          onTap: () => _showComplaintDetails(complaint),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showComplaintDetails(Map<String, dynamic> complaint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint['id'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          complaint['subject'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          complaint['status'] as String,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        complaint['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(complaint['status'] as String),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complaint Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Complainant',
                        complaint['complainant'] as String,
                      ),
                      _buildDetailRow('Type', complaint['type'] as String),
                      _buildDetailRow(
                        'Severity',
                        complaint['severity'] as String,
                      ),
                      _buildDetailRow(
                        'Date',
                        DateFormat(
                          'MMM dd, yyyy - hh:mm a',
                        ).format(complaint['date'] as DateTime),
                      ),
                      _buildDetailRow('Ride ID', complaint['rideId'] as String),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        complaint['description'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Complaint marked as resolved'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text(
                          'Resolve',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Warning issued'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        child: const Text(
                          'Issue Warning',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatLogsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _chatLogs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final chat = _chatLogs[i];
          return Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.primaryBlue,
                ),
              ),
              title: Text(
                'Ride ${chat['rideId']}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    '${chat['passenger']} ↔ ${chat['driver']}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${chat['messages']} messages • ${DateFormat('MMM dd, yyyy').format(chat['date'] as DateTime)}',
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
              trailing: Chip(
                label: Text(chat['status'] as String),
                backgroundColor: Colors.blue.withOpacity(0.2),
              ),
              onTap: () => _showChatDetails(chat),
            ),
          );
        },
      ),
    );
  }

  void _showChatDetails(Map<String, dynamic> chat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chat Log ${chat['id']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ride: ${chat['rideId']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        chat['status'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conversation Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Passenger', chat['passenger'] as String),
                      _buildDetailRow('Driver', chat['driver'] as String),
                      _buildDetailRow(
                        'Total Messages',
                        '${chat['messages']} messages',
                      ),
                      _buildDetailRow(
                        'Date',
                        DateFormat(
                          'MMM dd, yyyy - hh:mm a',
                        ).format(chat['date'] as DateTime),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Latest Message Preview',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chat['preview'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Full chat transcription downloaded',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text(
                          'View Full Chat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncidentsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _incidentLogs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final incident = _incidentLogs[i];
          return Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: _getSeverityColor(
                  incident['severity'] as String,
                ).withOpacity(0.2),
                child: Icon(
                  Icons.warning,
                  color: _getSeverityColor(incident['severity'] as String),
                ),
              ),
              title: Text(
                incident['type'] as String,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    incident['description'] as String,
                    style: const TextStyle(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat(
                      'MMM dd, yyyy - hh:mm a',
                    ).format(incident['date'] as DateTime),
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSeverityColor(
                    incident['severity'] as String,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  incident['severity'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getSeverityColor(incident['severity'] as String),
                  ),
                ),
              ),
              onTap: () => _showIncidentDetails(incident),
            ),
          );
        },
      ),
    );
  }

  void _showIncidentDetails(Map<String, dynamic> incident) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident['id'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          incident['type'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(
                          incident['severity'] as String,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        incident['severity'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getSeverityColor(
                            incident['severity'] as String,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Incident Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Description',
                        incident['description'] as String,
                      ),
                      _buildDetailRow(
                        'Involved Parties',
                        incident['involvedParties'] as String,
                      ),
                      _buildDetailRow(
                        'Date',
                        DateFormat(
                          'MMM dd, yyyy - hh:mm a',
                        ).format(incident['date'] as DateTime),
                      ),
                      _buildDetailRow('Status', incident['status'] as String),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Action Taken',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        incident['actionTaken'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSOSAlertsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _sosAlerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final sos = _sosAlerts[i];
          return Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: _getSeverityColor(
                  sos['severity'] as String,
                ).withOpacity(0.2),
                child: Icon(
                  Icons.emergency,
                  color: _getSeverityColor(sos['severity'] as String),
                ),
              ),
              title: Text(
                'SOS Alert ${sos['id']}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Passenger: ${sos['passenger']}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Response: ${sos['responseTime']} • ${DateFormat('MMM dd, yyyy - hh:mm a').format(sos['date'] as DateTime)}',
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    sos['status'] as String,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  sos['status'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(sos['status'] as String),
                  ),
                ),
              ),
              onTap: () => _showSOSDetails(sos),
            ),
          );
        },
      ),
    );
  }

  void _showSOSDetails(Map<String, dynamic> sos) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sos['id'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SOS Alert',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          sos['status'] as String,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sos['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(sos['status'] as String),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alert Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Passenger', sos['passenger'] as String),
                      _buildDetailRow('Driver', sos['driver'] as String),
                      _buildDetailRow('Ride ID', sos['rideId'] as String),
                      _buildDetailRow('Location', sos['location'] as String),
                      _buildDetailRow(
                        'Alert Time',
                        DateFormat(
                          'MMM dd, yyyy - hh:mm a',
                        ).format(sos['date'] as DateTime),
                      ),
                      _buildDetailRow(
                        'Response Time',
                        '${sos['responseTime']} (Emergency response)',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Issue Description',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sos['description'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if ((sos['status'] as String) != 'Resolved')
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('SOS Alert marked as resolved'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'Resolve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.orange;
      case 'Under Investigation':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      case 'Escalated':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsScreen extends StatefulWidget {
  final String userRole;
  const _SettingsScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _maintenanceMode = false;
  bool _twoFactorEnabled = false;
  bool _pushNotificationsEnabled = true;

  // Barangay and service zone sample data
  final List<String> _barangays = [
    'Bical',
    'Masiit',
    'Santa Cruz',
    'Tagum',
    'Cafate',
    'Cianopay',
    'Puting Bato',
    'Rosario',
  ];

  final List<Map<String, dynamic>> _serviceZones = [
    {
      'id': 'SZ001',
      'name': 'Downtown Mati',
      'barangays': ['Bical', 'Masiit'],
      'status': 'Active',
      'coverage': '85%',
    },
    {
      'id': 'SZ002',
      'name': 'Residential Zone',
      'barangays': ['Santa Cruz', 'Tagum'],
      'status': 'Active',
      'coverage': '90%',
    },
  ];

  final List<Map<String, dynamic>> _activityLogs = [
    {
      'id': 'LOG001',
      'admin': 'John Admin',
      'action': 'Updated service zone',
      'details': 'Downtown Mati - Coverage 85%',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'Success',
    },
  ];

  @override
  void initState() {
    super.initState();
    // super admin sees extra tabs
    int tabCount = widget.userRole == 'Super Admin' ? 6 : 4;
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get isSuperAdmin => widget.userRole == 'Super Admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.primaryYellow,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: [
            const Tab(text: 'System'),
            const Tab(text: 'Notifications'),
            if (isSuperAdmin) const Tab(text: 'Barangay'),
            if (isSuperAdmin) const Tab(text: 'Zones'),
            const Tab(text: 'Security'),
            if (isSuperAdmin) const Tab(text: 'Activity'),
          ],
        ),
      ),
      body: Container(
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
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSystemTab(),
            _buildNotificationsTab(),
            if (isSuperAdmin) _buildBarangayTab(),
            if (isSuperAdmin) _buildZonesTab(),
            _buildSecurityTab(),
            if (isSuperAdmin) _buildActivityTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Maintenance Mode',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Switch(
                value: _maintenanceMode,
                onChanged: (v) => setState(() => _maintenanceMode = v),
                activeColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _notificationToggle(
            'Emergency Alerts',
            'Critical safety incidents',
            true,
            (v) {},
          ),
          _notificationToggle(
            'System Updates',
            'Maintenance notices',
            _pushNotificationsEnabled,
            (v) {
              setState(() => _pushNotificationsEnabled = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBarangayTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Barangay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _barangays.length,
              itemBuilder: (_, i) => ListTile(title: Text(_barangays[i])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZonesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_location),
            label: const Text('Add Zone'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _serviceZones.length,
              itemBuilder: (_, i) {
                final z = _serviceZones[i];
                return ListTile(
                  title: Text(z['name'] as String),
                  subtitle: Text('Status: ${z['status']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Two‑Factor Authentication',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Switch(
                value: _twoFactorEnabled,
                onChanged: (v) => setState(() => _twoFactorEnabled = v),
                activeColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: _activityLogs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final log = _activityLogs[i];
          return ListTile(
            title: Text(log['action'] as String),
            subtitle: Text('By ${log['admin']}'),
          );
        },
      ),
    );
  }

  Widget _notificationToggle(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
        ),
      ],
    );
  }
}

class _LogsScreen extends StatefulWidget {
  const _LogsScreen({Key? key}) : super(key: key);

  @override
  State<_LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<_LogsScreen> {
  List<String> _logs = List.generate(
    20,
    (i) =>
        'Log entry ${i + 1} - ${DateTime.now().subtract(Duration(minutes: i * 5))}',
  );

  void _clearLogs() async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Clear logs?'),
            content: const Text('This will remove all logs (mock).'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Clear'),
              ),
            ],
          ),
        ) ??
        false;

    if (ok) {
      setState(() => _logs = []);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logs cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            onPressed: _clearLogs,
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: _logs.isEmpty
          ? const Center(child: Text('No logs'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) => ListTile(
                title: Text(_logs[i]),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _logs[i]));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied log to clipboard')),
                  );
                },
              ),
            ),
    );
  }
}
