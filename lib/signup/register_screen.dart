import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';
import '../login/widgets/login_widgets.dart';
import 'widgets/sign_up_widgets.dart';
import 'widgets/signup_background.dart';
import 'data/signup_repository.dart';
import 'verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final SignupRepository _repository = SignupRepository();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // This is just the INITIAL value for the UI
  String _userRole = 'Passenger';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showNotification(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SignupBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const SignupHeader(),
                  const SizedBox(height: 40),

                  // Role Selector must update the state correctly
                  RoleSelector(
                    selectedRole: _userRole,
                    onRoleSelected: (role) {
                      setState(() {
                        _userRole = role;
                      });
                    },
                  ),

                  const SizedBox(height: 32),
                  LoginInput(
                    controller: _emailController,
                    label: 'Email Address',
                  ),
                  const SizedBox(height: 20),
                  LoginInput(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: !_isPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoginInput(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: !_isConfirmPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(
                        () => _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(
                          label: 'Register Account',
                          onPressed: () async {
                            // CRITICAL: We use the CURRENT value of _userRole from the state
                            final String selectedRole = _userRole;
                            final String email = _emailController.text.trim();
                            final String password = _passwordController.text;

                            if (password != _confirmPasswordController.text) {
                              _showNotification(
                                "Passwords do not match",
                                isError: true,
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            try {
                              // Pass the selectedRole to the repository
                              await _repository.registerUser(
                                email,
                                password,
                                selectedRole,
                              );

                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VerificationScreen(email: email),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              setState(() => _isLoading = false);
                              _showNotification(e.toString(), isError: true);
                            }
                          },
                        ),
                  const SizedBox(height: 24),
                  // ... Login Prompt Row ...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
