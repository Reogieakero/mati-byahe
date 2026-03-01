import 'package:flutter/material.dart';

import '../core/constant/app_colors.dart';
import '../core/services/auth_service.dart';
import '../login/login_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  final String email;

  const DriverProfileScreen({super.key, required this.email});

  Future<void> _handleLogout(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut();

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _PlaceholderScreen(title: title)));
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF4F5F7);
    final emailPrefix = email.split('@').first;
    final displayName = emailPrefix.isEmpty
        ? 'Driver'
        : '${emailPrefix[0].toUpperCase()}${emailPrefix.substring(1)}';

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Driver Profile',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.30),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                      color: Colors.black.withValues(alpha: 0.10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFD9D9D9),
                      child: Text(
                        displayName[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black.withValues(alpha: 0.55),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.star, size: 15, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: _StatCard(title: 'Total Trips', value: '0'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(title: 'Total Earnings', value: '₱0.00'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _MenuTile(
                icon: Icons.wallet_outlined,
                title: 'Payment Methods',
                onTap: () => _openPlaceholder(context, 'Payment Methods'),
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.notifications_none_outlined,
                title: 'Notifications',
                onTap: () => _openPlaceholder(context, 'Notifications'),
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.shield_outlined,
                title: 'Privacy & Security',
                onTap: () => _openPlaceholder(context, 'Privacy & Security'),
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => _openPlaceholder(context, 'Help & Support'),
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.history,
                title: 'Trip History',
                showChevron: false,
                onTap: () => _openPlaceholder(context, 'Trip History'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _handleLogout(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1),
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout_outlined),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withValues(alpha: 0.28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black.withValues(alpha: 0.35), size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              if (showChevron)
                Text(
                  '>',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title screen (connect module here)',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
