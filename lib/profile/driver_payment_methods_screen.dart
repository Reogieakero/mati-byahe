import 'package:flutter/material.dart';

import '../core/constant/app_colors.dart';

class DriverPaymentMethodsScreen extends StatefulWidget {
  const DriverPaymentMethodsScreen({super.key});

  @override
  State<DriverPaymentMethodsScreen> createState() =>
      _DriverPaymentMethodsScreenState();
}

class _DriverPaymentMethodsScreenState
    extends State<DriverPaymentMethodsScreen> {
  bool cashEnabled = true;
  bool eWalletEnabled = true;
  bool bankTransferEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkNavy,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'PAYMENT METHODS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(15, 16, 15, 24),
        children: [
          _sectionLabel('AVAILABLE METHODS'),
          const SizedBox(height: 10),
          _card(
            children: [
              _methodTile(
                icon: Icons.payments_outlined,
                title: 'Cash',
                subtitle: 'Receive payments directly in person.',
                value: cashEnabled,
                onChanged: (v) => setState(() => cashEnabled = v),
              ),
              _divider(),
              _methodTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'E-Wallet',
                subtitle: 'Accept payments via supported wallets.',
                value: eWalletEnabled,
                onChanged: (v) => setState(() => eWalletEnabled = v),
              ),
              _divider(),
              _methodTile(
                icon: Icons.account_balance_outlined,
                title: 'Bank Transfer',
                subtitle: 'Receive transfers to linked bank account.',
                value: bankTransferEnabled,
                onChanged: (v) => setState(() => bankTransferEnabled = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionLabel('PAYOUT ACCOUNT'),
          const SizedBox(height: 10),
          _card(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.credit_card_rounded,
                  color: AppColors.primaryBlue,
                ),
                title: const Text(
                  'No payout account linked',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                subtitle: Text(
                  'Add an account for weekly payouts.',
                  style: TextStyle(
                    color: AppColors.textGrey.withValues(alpha: 0.95),
                  ),
                ),
                trailing: OutlinedButton(
                  onPressed: () => _showComingSoon('Add Account'),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w800,
      color: AppColors.textGrey.withValues(alpha: 0.75),
      letterSpacing: 1.5,
    ),
  );

  Widget _card({required List<Widget> children}) => Container(
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
    child: Column(children: children),
  );

  Widget _divider() => Divider(
    height: 1,
    indent: 56,
    endIndent: 14,
    color: Colors.grey.withValues(alpha: 0.10),
  );

  Widget _methodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: AppColors.primaryBlue),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textGrey.withValues(alpha: 0.95),
        ),
      ),
      activeThumbColor: AppColors.primaryBlue,
      activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.35),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be connected to backend soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
