import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/confirmation_dialog.dart';
import '../core/constant/app_colors.dart';
import '../core/database/local_database.dart';
import '../core/services/auth_service.dart';
import '../core/theme/theme_service.dart';
import '../login/login_screen.dart';
import 'avatar_storage.dart';
import 'driver_payment_methods_screen.dart';
import 'driver_trip_history_screen.dart';
import 'edit_profile_screen.dart';
import 'guide_screen.dart';
import 'legal_screen.dart';
import 'set_pin_screen.dart';

class DriverProfileScreen extends StatefulWidget {
  final String email;

  const DriverProfileScreen({super.key, required this.email});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final AuthService _authService = AuthService();
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;

  String? _userName;
  String? _userPhone;
  String? _avatarBase64;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await _supabase
          .from('profiles')
          .select('full_name, phone_number')
          .eq('id', user.id)
          .maybeSingle();

      _avatarBase64 = await AvatarStorage.getAvatarBase64(user.id);

      if (mounted) {
        setState(() {
          _userName = data?['full_name'];
          _userPhone = data?['phone_number'];
          _isLoading = false;
        });
      }

      if (data != null) {
        await _localDb.updateUserProfile(
          id: user.id,
          name: _userName ?? '',
          phone: _userPhone ?? '',
        );
      }
    } catch (_) {
      final localData = await _localDb.getUserById(user.id);
      _avatarBase64 = await AvatarStorage.getAvatarBase64(user.id);
      if (mounted) {
        setState(() {
          _userName = localData?['full_name'];
          _userPhone = localData?['phone_number'];
          _isLoading = false;
        });
      }
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Logout',
        content: 'Are you sure you want to log out of your account?',
        confirmText: 'Logout',
        onConfirm: () async {
          await _authService.signOut();
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = (_userName == null || _userName!.trim().isEmpty)
        ? widget.email.split('@').first
        : _userName!;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FB),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgYellowStart,
              AppColors.bgYellowMid,
              AppColors.bgYellowEnd,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
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
                _buildHeaderCard(displayName),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Total Trips',
                        value: '0',
                        background: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Total Earnings',
                        value: '₱0.00',
                        background: AppColors.darkNavy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionLabel('ACCOUNT OVERVIEW'),
                const SizedBox(height: 10),
                _GroupCard(
                  children: [
                    _GroupItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile',
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              initialName: _userName ?? '',
                              initialEmail: widget.email,
                              initialPhone: _userPhone ?? '',
                            ),
                          ),
                        );
                        if (result == true) _fetchUserData();
                      },
                    ),
                    const _GroupDivider(),
                    _GroupItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Login PIN',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SetPinScreen(),
                          ),
                        );
                      },
                    ),
                    const _GroupDivider(),
                    _GroupItem(
                      icon: Icons.wallet_outlined,
                      title: 'Payment Methods',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverPaymentMethodsScreen(),
                          ),
                        );
                      },
                    ),
                    const _GroupDivider(),
                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: ThemeService.themeModeNotifier,
                      builder: (context, mode, _) {
                        final isDark = mode == ThemeMode.dark;
                        return SwitchListTile.adaptive(
                          value: isDark,
                          activeThumbColor: AppColors.primaryBlue,
                          activeTrackColor: AppColors.primaryBlue.withValues(
                            alpha: 0.35,
                          ),
                          secondary: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(
                              isDark
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              size: 21,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          title: const Text(
                            'Dark Mode',
                            style: TextStyle(
                              color: AppColors.darkNavy,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          onChanged: (value) async {
                            await ThemeService.toggleDarkMode(value);
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const _SectionLabel('SUPPORT & LEGAL'),
                const SizedBox(height: 10),
                _GroupCard(
                  children: [
                    _GroupItem(
                      icon: Icons.auto_stories_rounded,
                      title: 'App Guide',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GuideScreen(role: 'driver'),
                          ),
                        );
                      },
                    ),
                    const _GroupDivider(),
                    _GroupItem(
                      icon: Icons.gavel_rounded,
                      title: 'Legal & Privacy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LegalScreen(),
                          ),
                        );
                      },
                    ),
                    const _GroupDivider(),
                    _GroupItem(
                      icon: Icons.history_rounded,
                      title: 'Trip History',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverTripHistoryScreen(),
                          ),
                        );
                      },
                    ),
                    const _GroupDivider(),
                    _GroupItem(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      onTap: _handleLogout,
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

  Widget _buildHeaderCard(String displayName) {
    final avatar = _avatarBase64;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.18),
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.12),
            backgroundImage: avatar != null && avatar.isNotEmpty
                ? MemoryImage(base64Decode(avatar))
                : null,
            child: (avatar == null || avatar.isEmpty)
                ? Text(
                    displayName.isEmpty ? 'D' : displayName[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey.withValues(alpha: 0.95),
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                    SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color background;

  const _StatCard({
    required this.title,
    required this.value,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
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
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textGrey.withValues(alpha: 0.9),
        fontSize: 10,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final List<Widget> children;

  const _GroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _GroupDivider extends StatelessWidget {
  const _GroupDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 58,
      endIndent: 16,
      color: Colors.grey.withValues(alpha: 0.10),
    );
  }
}

class _GroupItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _GroupItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final itemIconColor = iconColor ?? AppColors.primaryBlue;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: itemIconColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, size: 21, color: itemIconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? AppColors.darkNavy,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textGrey,
        size: 22,
      ),
    );
  }
}
