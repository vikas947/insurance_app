import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6, (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String? _errorMessage;
  int _resendSeconds = 30;
  Timer? _resendTimer;

  // Figma Colors
  static const Color primaryMaroon = Color(0xFF621817);
  static const Color textBlack = Color(0xFF111111);
  static const Color textGrey = Color(0xFF666666);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color bgWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    Future.microtask(() {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _otpControllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();

  void _clearError() {
    if (_errorMessage != null) setState(() => _errorMessage = null);
  }

  void _handleOtpInput(String value, int index) {
    _clearError();
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_otpValue.length == 6) {
      _verifyOtp();
    }
  }

  void _handleBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    _clearError();
    final otp = _otpValue;
    debugPrint('[OtpScreen] Verifying OTP: $otp for ${widget.mobile}');

    if (otp.length < 6) {
      setState(() => _errorMessage = 'Please enter complete 6-digit OTP');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyOtp(widget.mobile, otp);
    debugPrint('[OtpScreen] verifyOtp returned: $success');

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      setState(() => _errorMessage = authProvider.errorMessage ?? 'Invalid OTP. Please try again.');
      for (final c in _otpControllers) { c.clear(); }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendOtp(widget.mobile);

    if (!mounted) return;

    if (success) {
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      setState(() => _errorMessage = 'Failed to resend OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── TOP SECTION (same as login screen) ──
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
              child: Column(
                children: [
                  // Back button + Logo row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: textBlack),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.pets, color: primaryMaroon, size: 28),
                      const SizedBox(width: 6),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("IndusInd",
                              style: TextStyle(
                                  color: primaryMaroon,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  height: 1.1)),
                          Text("INSURANCE",
                              style: TextStyle(
                                  color: primaryMaroon,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  height: 1.1,
                                  letterSpacing: 0.3)),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(width: 40), // Balance for back button
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Skyline
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.location_city, size: 50, color: borderGrey.withValues(alpha: 0.4)),
                  Icon(Icons.location_city, size: 60, color: borderGrey.withValues(alpha: 0.4)),
                  Icon(Icons.location_city, size: 55, color: borderGrey.withValues(alpha: 0.4)),
                  Icon(Icons.location_city, size: 45, color: borderGrey.withValues(alpha: 0.4)),
                ],
              ),
            ),

            // ── BOTTOM SHEET ──
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgWhite,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          "Verify your Mobile Number",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: primaryMaroon,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Row(
                          children: [
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textGrey,
                                    fontFamily: 'Inter',
                                  ),
                                  children: [
                                    const TextSpan(text: "OTP sent to "),
                                    TextSpan(
                                      text: "+91 ${widget.mobile}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: textBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryMaroon.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primaryMaroon,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Section label
                        const Text(
                          "Enter 6-Digit OTP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textBlack,
                            fontFamily: 'Inter',
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── OTP 6 BOXES ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 48,
                              height: 56,
                              child: KeyboardListener(
                                focusNode: FocusNode(),
                                onKeyEvent: (event) {
                                  if (event is KeyDownEvent &&
                                      event.logicalKey == LogicalKeyboardKey.backspace) {
                                    _handleBackspace(index);
                                  }
                                },
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: textBlack,
                                    fontFamily: 'Inter',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    counterText: '',
                                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                    filled: true,
                                    fillColor: bgWhite,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: borderGrey, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: _errorMessage != null ? Colors.red : borderGrey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: primaryMaroon, width: 2),
                                    ),
                                  ),
                                  onChanged: (val) => _handleOtpInput(val, index),
                                ),
                              ),
                            );
                          }),
                        ),

                        // Error message
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Verify Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: textBlack,
                              foregroundColor: bgWhite,
                              disabledBackgroundColor: textBlack.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 24, height: 24,
                                    child: CircularProgressIndicator(
                                      color: bgWhite, strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Verify OTP",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Resend Timer
                        Center(
                          child: GestureDetector(
                            onTap: _resendSeconds == 0 ? _resendOtp : null,
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                children: _resendSeconds > 0
                                    ? [
                                        const TextSpan(
                                          text: "Resend OTP in ",
                                          style: TextStyle(color: textGrey),
                                        ),
                                        TextSpan(
                                          text: "${_resendSeconds}s",
                                          style: const TextStyle(
                                            color: primaryMaroon,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ]
                                    : [
                                        const TextSpan(
                                          text: "Resend OTP",
                                          style: TextStyle(
                                            color: primaryMaroon,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Terms
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: textGrey,
                                fontFamily: 'Inter',
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: "By signing up, you agree to the "),
                                TextSpan(
                                  text: "Terms of Service",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: primaryMaroon,
                                  ),
                                ),
                                TextSpan(text: " and "),
                                TextSpan(
                                  text: "Data\nProcessing Agreement",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: primaryMaroon,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
