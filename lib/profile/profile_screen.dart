import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';
import '../core/services/auth_service.dart';
import '../login/login_screen.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String email;
  final String role;
  final String? name;
  final String? phoneNumber;

  const ProfileScreen({
    super.key,
    required this.email,
    required this.role,
    this.name,
    this.phoneNumber,
  });

  static const Color backgroundColor = Color(0xFFF8F9FB);

  void _handleLogout(BuildContext context) async {
    final AuthService authService = AuthService();
    await authService.signOut();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          _buildGradientBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      ProfileHeader(email: email),
                      const SizedBox(height: 32),
                      _buildSectionLabel("ACCOUNT OVERVIEW"),
                      _buildContentCard(
                        child: ProfileMenuItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Edit Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  initialName: name ?? "",
                                  initialEmail: email,
                                  initialPhone: phoneNumber ?? "",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionLabel("PREFERENCES & SUPPORT"),
                      _buildContentCard(
                        child: Column(
                          children: [
                            ProfileMenuItem(
                              icon: Icons.help_outline_rounded,
                              title: 'Help Center',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            ProfileMenuItem(
                              icon: Icons.info_outline_rounded,
                              title: 'Legal & Privacy',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            ProfileMenuItem(
                              icon: Icons.logout_rounded,
                              title: 'Logout',
                              titleColor: Colors.redAccent,
                              iconColor: Colors.redAccent,
                              onTap: () => _handleLogout(context),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue.withValues(alpha: 0.12),
              backgroundColor,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return const SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        "MY ACCOUNT",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: AppColors.darkNavy,
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.textGrey.withValues(alpha: 0.7),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }

  Widget _buildDivider() => Divider(
    height: 1,
    color: Colors.grey.withValues(alpha: 0.08),
    indent: 56,
    endIndent: 16,
  );
}
