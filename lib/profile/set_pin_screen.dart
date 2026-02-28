import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constant/app_colors.dart';
import '../core/database/local_database.dart';
import '../core/database/sync_service.dart';
import '../components/confirmation_dialog.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _supabase = Supabase.instance.client;
  final _localDb = LocalDatabase();
  final _syncService = SyncService();
  String _pin = "";
  final int _pinLength = 4;
  bool _isSaving = false;

  void _onKeyTap(String value) {
    if (_pin.length < _pinLength && !_isSaving) {
      setState(() => _pin += value);
    }
    if (_pin.length == _pinLength && !_isSaving) {
      _showConfirmDialog();
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty && !_isSaving) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(
        title: "Security Lock",
        content:
            "Are you sure you want to set this 4-digit PIN as your login credential?",
        confirmText: "Set PIN",
        onConfirm: _handleSavePin,
      ),
    ).then((_) {
      if (!_isSaving && _pin.length == _pinLength) {
        setState(() => _pin = "");
      }
    });
  }

  Future<void> _handleSavePin() async {
    setState(() => _isSaving = true);
    final user = _supabase.auth.currentUser;

    if (user == null) {
      setState(() => _isSaving = false);
      return;
    }

    try {
      await _localDb.updateLocalPin(user.id, _pin);
      await _syncService.syncOnStart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PIN secured locally and synced successfully!"),
            backgroundColor: AppColors.primaryBlue,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _pin = "";
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkNavy,
        title: const Text(
          "LOGIN PIN",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              _isSaving ? "Securing PIN..." : "Enter a 4-digit PIN",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkNavy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This PIN will be required to access your account.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            if (_isSaving)
              const CircularProgressIndicator(color: AppColors.primaryBlue)
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (index) {
                  bool isFilled = index < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? AppColors.primaryBlue
                          : Colors.grey.withOpacity(0.2),
                    ),
                  );
                }),
              ),
            const Spacer(),
            Opacity(opacity: _isSaving ? 0.5 : 1.0, child: _buildNumPad()),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad() {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((num) => _buildNumButton(num)).toList(),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 60),
            _buildNumButton('0'),
            SizedBox(
              width: 60,
              child: IconButton(
                onPressed: _onBackspace,
                icon: const Icon(
                  Icons.backspace_outlined,
                  color: AppColors.darkNavy,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumButton(String text) {
    return InkWell(
      onTap: () => _onKeyTap(text),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
          ),
        ),
      ),
    );
  }
}
