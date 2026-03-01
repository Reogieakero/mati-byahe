import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constant/app_colors.dart';
import '../core/database/local_database.dart';
import '../profile/avatar_storage.dart';
import '../profile/driver_trip_history_screen.dart';
import '../report/report_history_screen.dart';
import 'widgets/home_header.dart';
import 'widgets/dashboard_cards.dart';
import 'widgets/verification_overlay.dart';
import 'widgets/location_selector.dart';
import 'widgets/action_grid_widget.dart';
import 'widgets/active_trip_widget.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  final String role;
  const HomeScreen({super.key, required this.email, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final HomeController _controller = HomeController();
  bool _isVerified = false;
  bool _isLoading = true;
  bool _isSendingCode = false;
  String _displayName = '';
  String? _avatarBase64;

  Map<String, dynamic>? _activeTripData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final verified = await _controller.checkVerification(widget.email);
    final activeData = await _controller.loadSavedFare(widget.email);
    await _loadProfileData();

    if (mounted) {
      setState(() {
        _isVerified = verified;
        if (activeData != null) {
          _activeTripData = activeData;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProfileData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _displayName = widget.email;
      return;
    }

    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();

      final cloudName = (data?['full_name'] as String?)?.trim();
      _avatarBase64 = await AvatarStorage.getAvatarBase64(user.id);

      if (cloudName != null && cloudName.isNotEmpty) {
        _displayName = cloudName;
        return;
      }
    } catch (_) {}

    final localUser = await LocalDatabase().getUserById(user.id);
    final localName = (localUser?['full_name'] as String?)?.trim();
    _avatarBase64 = await AvatarStorage.getAvatarBase64(user.id);

    _displayName = (localName != null && localName.isNotEmpty)
        ? localName
        : widget.email;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryYellow.withValues(alpha: 0.2),
              Colors.white,
              AppColors.primaryYellow.withValues(alpha: 0.1),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: !_isVerified ? _buildRestrictedView() : _buildHomeContent(),
      ),
    );
  }

  Widget _buildRestrictedView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_person_rounded,
              size: 80,
              color: AppColors.primaryYellow,
            ),
            const SizedBox(height: 24),
            const Text(
              "Access Restricted",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 32),
            VerificationOverlay(
              isSendingCode: _isSendingCode,
              onVerify: () => _controller.handleVerification(
                context: context,
                email: widget.email,
                setSendingState: (s) => setState(() => _isSendingCode = s),
                onReturn: _initialize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final isDriver = widget.role.trim().toLowerCase() == 'driver';
    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDriver) ...[
                  _buildDriverWelcomeCard(),
                  const SizedBox(height: 10),
                  _buildDriverQuickStats(),
                  const SizedBox(height: 8),
                  _buildDriverQuickActions(),
                ],
                const SizedBox(height: 10),
                DashboardCards(
                  tripCount: 4,
                  driverName: widget.role.trim().toLowerCase() == 'driver'
                      ? "You"
                      : "Lito Lapid",
                  plateNumber: "CLB 4930",
                  email: widget.email,
                  displayName: _displayName,
                  role: widget.role,
                  avatarBase64: _avatarBase64,
                ),
                ActionGridWidget(
                  isDriver: isDriver,
                  onReportTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReportHistoryScreen(),
                      ),
                    );
                  },
                  onNewsTap: _showNewsSheet,
                  onTrackTap: () {
                    if (isDriver) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DriverTripHistoryScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Tracking tools are available in History.',
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _activeTripData != null
                      ? _buildActiveTrip()
                      : _buildLocationSelector(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveTrip() {
    final fareValue = (_activeTripData?['fare'] as num?)?.toDouble() ?? 0.0;

    return ActiveTripWidget(
      fare: fareValue,
      onArrived: () => _controller.confirmArrival(context, () {
        _controller.clearFare(
          email: widget.email,
          pickup: _activeTripData?['pickup'] ?? "Unknown",
          dropOff: _activeTripData?['drop_off'] ?? "Unknown",
          gasTier: _activeTripData?['gas_tier'] ?? "N/A",
          fare: fareValue,
          startTime: _activeTripData?['start_time'],
          onCleared: () => setState(() => _activeTripData = null),
        );
      }),
      onCancel: () => _controller.confirmChangeRoute(context, () {
        _controller.clearFare(
          email: widget.email,
          pickup: "Cancelled",
          dropOff: "Cancelled",
          gasTier: "N/A",
          fare: 0.0,
          startTime: _activeTripData?['start_time'],
          onCleared: () => setState(() => _activeTripData = null),
        );
      }),
    );
  }

  Widget _buildLocationSelector() {
    return LocationSelector(
      email: widget.email,
      onFareCalculated: (fare) async {
        final updatedData = await _controller.loadSavedFare(widget.email);
        setState(() {
          _activeTripData = updatedData;
        });
      },
    );
  }

  Widget _buildDriverWelcomeCard() {
    final firstName = _displayName.trim().split(' ').first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.wb_sunny_rounded, color: AppColors.primaryYellow),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, $firstName',
                    style: const TextStyle(
                      color: AppColors.darkNavy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'You are set for today\'s trips.',
                    style: TextStyle(
                      color: AppColors.textGrey.withValues(alpha: 0.95),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text(
                'ONLINE',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _smallStatCard(
              label: 'Today',
              value: '4 trips',
              icon: Icons.route_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _smallStatCard(
              label: 'Rating',
              value: '4.9',
              icon: Icons.star_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _smallStatCard(
              label: 'Earnings',
              value: '₱0.00',
              icon: Icons.payments_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
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
              color: AppColors.darkNavy,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textGrey.withValues(alpha: 0.95),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _showChecklistSheet,
              icon: const Icon(Icons.checklist_rounded),
              label: const Text('Checklist'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quick support coming soon.')),
              ),
              icon: const Icon(Icons.support_agent_rounded),
              label: const Text('Support'),
            ),
          ),
        ],
      ),
    );
  }

  void _showChecklistSheet() {
    bool docs = false;
    bool fuel = false;
    bool brakes = false;
    bool phone = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pre-Trip Checklist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Complete before accepting bookings.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey.withValues(alpha: 0.95),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: docs,
                      onChanged: (v) => setModalState(() => docs = v ?? false),
                      title: const Text('Driver license and docs checked'),
                      dense: true,
                      activeColor: AppColors.primaryBlue,
                    ),
                    CheckboxListTile(
                      value: fuel,
                      onChanged: (v) => setModalState(() => fuel = v ?? false),
                      title: const Text('Fuel level is enough for today'),
                      dense: true,
                      activeColor: AppColors.primaryBlue,
                    ),
                    CheckboxListTile(
                      value: brakes,
                      onChanged: (v) =>
                          setModalState(() => brakes = v ?? false),
                      title: const Text('Brakes, lights, and tires are good'),
                      dense: true,
                      activeColor: AppColors.primaryBlue,
                    ),
                    CheckboxListTile(
                      value: phone,
                      onChanged: (v) => setModalState(() => phone = v ?? false),
                      title: const Text('Phone battery and data are ready'),
                      dense: true,
                      activeColor: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: (docs && fuel && brakes && phone)
                            ? () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Checklist completed. You are ready to drive.',
                                    ),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.verified_rounded),
                        label: const Text('Mark as Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNewsSheet() {
    const items = [
      ('Fare policy update', 'New fare matrix draft now available for review.'),
      (
        'Driver verification',
        'Monthly account verification starts this weekend.',
      ),
      ('Peak hours advisory', 'Expect high demand between 5PM and 8PM today.'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Driver News & Updates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: 10),
                ...items.map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.circle_notifications_rounded,
                      color: AppColors.primaryBlue,
                    ),
                    title: Text(
                      e.$1,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(e.$2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
