import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';

import '../widgets/auth_layout.dart';
import '../widgets/primary_button.dart';
import '../widgets/link_text.dart';
import '../widgets/terms_text.dart';
import '../widgets/status_dialog.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 30;
  Timer? _timer;
  bool _isVerifying = false;
  bool _canResend = false;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendSeconds = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  bool get _isOtpComplete => _controllers.every((c) => c.text.isNotEmpty);

  Future<void> _handleVerify() async {
    if (!_isOtpComplete || _isVerifying) return;
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isVerifying = false);
    
    if (!mounted) return;

    // Simulate OTP validation
    String enteredOtp = _controllers.map((c) => c.text).join();
    if (enteredOtp == "156272") { // Matching the image's example OTP
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() => _failedAttempts++);
      if (_failedAttempts >= 3) {
        StatusDialog.show(
          context,
          title: "Too Many Incorrect OTP Entries",
          subtitle: "You've entered the wrong OTP too many times. Please try again after 24 hours.",
          buttonText: "Okay",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      pinnedBottom: const TermsText(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verify your Mobile Number",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  "Auto filling OTP sent to ${widget.mobile}",
                  style: const TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ),
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
            "Enter 6-Digit OTP Manually",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
          ),
          const SizedBox(height: 16),
          _buildOtpInput(),
          const SizedBox(height: 24),
          Center(
            child: LinkText(
              text: _canResend ? "Resend OTP" : "Resend OTP in ${_resendSeconds}s",
              onTap: _canResend ? _startResendTimer : null,
              isDisabled: !_canResend,
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: "Verify",
            isLoading: _isVerifying,
            onPressed: _isOtpComplete ? _handleVerify : null,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInput() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          const Text(
            "AVC -",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black, letterSpacing: 1),
          ),
          const SizedBox(width: 4),
          ...List.generate(6, (index) {
            return Expanded(
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  setState(() {});
                  if (_isOtpComplete) _handleVerify();
                },
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.black),
                decoration: const InputDecoration(
                  counterText: "",
                  hintText: "X",
                  hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFBBBBBB)),
                  border: InputBorder.none,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
