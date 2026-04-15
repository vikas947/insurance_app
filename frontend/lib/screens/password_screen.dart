import 'package:flutter/material.dart';
import '../core/app_theme.dart';

import '../widgets/auth_layout.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/link_text.dart';
import '../widgets/terms_text.dart';
import '../widgets/status_dialog.dart';
import 'home_screen.dart';

class PasswordScreen extends StatefulWidget {
  final String email;

  const PasswordScreen({super.key, required this.email});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorText;
  int _failedAttempts = 0;
  static const int _maxAttempts = 5;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() => _errorText = null));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isCtaEnabled => _passwordController.text.isNotEmpty && !_isLoading;

  Future<void> _handleSubmit() async {
    if (_passwordController.text.length < 6) {
      setState(() => _errorText = "Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _isLoading = false);

    if (_passwordController.text != "Vik@98765" && _passwordController.text != "123456") {
      setState(() {
        _failedAttempts++;
        int remaining = _maxAttempts - _failedAttempts;
        if (remaining > 0) {
          _errorText = "Incorrect password. You have $remaining attempts left.";
        } else {
          _errorText = null;
          StatusDialog.show(
            context,
            title: "Too Many Incorrect Attempts",
            subtitle: "You've entered the wrong password too many times. Please try again after 24 hours.",
            buttonText: "Okay",
          );
        }
      });
    } else {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _handleForgotPassword() {
    StatusDialog.show(
      context,
      isError: false,
      icon: Icons.email_outlined,
      iconColor: const Color(0xFF4A1010),
      title: "Password Sent to Your Email",
      subtitle: "We've emailed you a new password. Use it to log in now or reset it later for security.",
      buttonText: "Use New Password",
      onButtonPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      pinnedBottom: const TermsText(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Your Password",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text("Logging in as ${widget.email}", style: const TextStyle(fontSize: 14, color: AppColors.grey)),
              const SizedBox(width: 8),
              LinkText(
                text: "Edit",
                icon: Icons.edit_outlined,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "Password",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
          ),
          const SizedBox(height: 8),
          InputField(
            controller: _passwordController,
            hintText: "Enter Your Password",
            obscureText: _obscurePassword,
            errorText: _errorText,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.grey,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _handleForgotPassword,
              child: const LinkText(text: "Forgot Password", isUnderlined: true),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: _passwordController.text.isEmpty ? "Login with Password" : "Submit",
            isLoading: _isLoading,
            onPressed: _isCtaEnabled ? _handleSubmit : null,
          ),
        ],
      ),
    );
  }
}
