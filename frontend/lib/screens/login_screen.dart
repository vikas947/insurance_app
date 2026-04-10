import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'otp_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isMobileTab = true;
  bool _obscurePassword = true;

  // Validation error texts
  String? _mobileError;
  String? _emailError;
  String? _passwordError;

  // Figma Colors
  static const Color primaryMaroon = Color(0xFF621817);
  static const Color textBlack = Color(0xFF111111);
  static const Color textGrey = Color(0xFF666666);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color bgWhite = Color(0xFFFFFFFF);

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    if (_mobileError != null || _emailError != null || _passwordError != null) {
      setState(() {
        _mobileError = null;
        _emailError = null;
        _passwordError = null;
      });
    }
  }

  bool _validateMobile(String mobile) {
    if (mobile.isEmpty) {
      setState(() => _mobileError = 'Please enter mobile number');
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      setState(() => _mobileError = 'Mobile number must contain only digits');
      return false;
    }
    if (mobile.length != 10) {
      setState(() => _mobileError = 'Please enter a valid 10-digit mobile number');
      return false;
    }
    return true;
  }

  bool _validateEmailLogin(String email, String password) {
    bool isValid = true;
    if (email.isEmpty) {
      setState(() => _emailError = 'Please enter email address');
      isValid = false;
    } else if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = 'Please enter password');
      isValid = false;
    } else if (password.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      isValid = false;
    }
    return isValid;
  }

  // ═══════════════════════════════════════════════════════════════
  // MOBILE → SEND OTP → NAVIGATE TO OTP SCREEN
  // ═══════════════════════════════════════════════════════════════
  Future<void> _handleMobileSubmit() async {
    _clearErrors();
    final mobile = _mobileController.text.trim();
    debugPrint('[LoginScreen] Mobile submit: "$mobile"');

    if (!_validateMobile(mobile)) {
      debugPrint('[LoginScreen] Validation failed');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendOtp(mobile);
    debugPrint('[LoginScreen] sendOtp returned: $success');

    if (!mounted) return;

    if (success) {
      debugPrint('[LoginScreen] Navigating to OTP screen');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(mobile: mobile)),
      );
    } else {
      _showError(authProvider.errorMessage ?? 'Failed to send OTP');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // EMAIL → LOGIN → NAVIGATE TO DASHBOARD
  // ═══════════════════════════════════════════════════════════════
  Future<void> _handleEmailSubmit() async {
    _clearErrors();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    debugPrint('[LoginScreen] Email submit: "$email"');

    if (!_validateEmailLogin(email, password)) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.loginEmail(email, password);
    debugPrint('[LoginScreen] loginEmail returned: $success');

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      _showError(authProvider.errorMessage ?? 'Invalid credentials');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GOOGLE LOGIN
  // ═══════════════════════════════════════════════════════════════
  Future<void> _handleGoogleLogin() async {
    debugPrint('[LoginScreen] Google login tapped');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      _showError(authProvider.errorMessage ?? 'Google sign-in failed');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // FACEBOOK LOGIN
  // ═══════════════════════════════════════════════════════════════
  Future<void> _handleFacebookLogin() async {
    debugPrint('[LoginScreen] Facebook login tapped');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithFacebook();

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else {
      _showError(authProvider.errorMessage ?? 'Facebook sign-in failed');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── TOP: Logo + Title + Illustration ──
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Column(
                children: [
                  // Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pets, color: primaryMaroon, size: 36),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("IndusInd",
                              style: TextStyle(
                                  color: primaryMaroon,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  height: 1.1)),
                          Text("INSURANCE",
                              style: TextStyle(
                                  color: primaryMaroon,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  height: 1.1,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Welcome text
                  const Text(
                    "Welcome to Self-i",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: primaryMaroon,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Login or sign up with your mobile number\nor email ID.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textBlack,
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Skyline illustration
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.location_city, size: 60, color: borderGrey.withValues(alpha: 0.5)),
                      Icon(Icons.location_city, size: 80, color: borderGrey.withValues(alpha: 0.5)),
                      Icon(Icons.location_city, size: 70, color: borderGrey.withValues(alpha: 0.5)),
                      Icon(Icons.location_city, size: 50, color: borderGrey.withValues(alpha: 0.5)),
                    ],
                  ),
                  Positioned(
                    left: size.width * 0.05,
                    bottom: 0,
                    child: const Icon(Icons.person, size: 70, color: Colors.orangeAccent),
                  ),
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
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      children: [
                        // ── TABS ──
                        _buildTabs(),
                        const SizedBox(height: 28),

                        // ── FORM ──
                        if (_isMobileTab) _buildMobileField() else _buildEmailFields(),
                        const SizedBox(height: 28),

                        // ── CTA BUTTON ──
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : (_isMobileTab ? _handleMobileSubmit : _handleEmailSubmit),
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
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: bgWhite, strokeWidth: 2),
                                  )
                                : Text(
                                    _isMobileTab ? "Verify with OTP" : "Enter Password",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── OR DIVIDER ──
                        Row(
                          children: [
                            const Expanded(child: Divider(color: borderGrey, thickness: 1)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Or login with",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textGrey,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: borderGrey, thickness: 1)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── SOCIAL: GOOGLE ──
                        _buildSocialButton(
                          label: "Continue with Google",
                          icon: Icons.g_mobiledata,
                          iconColor: Colors.red,
                          onTap: _handleGoogleLogin,
                        ),
                        const SizedBox(height: 16),

                        // ── SOCIAL: FACEBOOK ──
                        _buildSocialButton(
                          label: "Continue with Facebook",
                          icon: Icons.facebook,
                          iconColor: const Color(0xFF1877F2),
                          onTap: _handleFacebookLogin,
                        ),

                        const SizedBox(height: 36),

                        // ── TERMS ──
                        RichText(
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
                                    fontWeight: FontWeight.w700, color: textBlack),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Data\nProcessing Agreement",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: textBlack),
                              ),
                            ],
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

  // ═══════════════════════════════════════════════════════════════
  // WIDGET: Tabs
  // ═══════════════════════════════════════════════════════════════
  Widget _buildTabs() {
    return Row(
      children: [
        _buildTab("Mobile Number", isActive: _isMobileTab, onTap: () {
          setState(() { _isMobileTab = true; });
          _clearErrors();
        }),
        _buildTab("Email Address", isActive: !_isMobileTab, onTap: () {
          setState(() { _isMobileTab = false; });
          _clearErrors();
        }),
      ],
    );
  }

  Widget _buildTab(String label, {required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? primaryMaroon : borderGrey,
                width: isActive ? 2.5 : 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? primaryMaroon : textGrey,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // WIDGET: Mobile Input with +91 prefix
  // ═══════════════════════════════════════════════════════════════
  Widget _buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => _clearErrors(),
          style: const TextStyle(
            fontSize: 16,
            color: textBlack,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: bgWhite,
            hintText: '99847 92739',
            hintStyle: TextStyle(
              color: textGrey.withValues(alpha: 0.5),
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("🇮🇳", style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  const Text(
                    "+91",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: textBlack,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: textGrey, size: 18),
                  const SizedBox(width: 12),
                  Container(width: 1, height: 24, color: borderGrey),
                ],
              ),
            ),
            border: _inputBorder(borderGrey),
            enabledBorder: _inputBorder(_mobileError != null ? Colors.red : borderGrey),
            focusedBorder: _inputBorder(_mobileError != null ? Colors.red : textBlack, width: 1.5),
            errorBorder: _inputBorder(Colors.red),
            focusedErrorBorder: _inputBorder(Colors.red, width: 1.5),
          ),
        ),
        if (_mobileError != null) _buildErrorText(_mobileError!),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // WIDGET: Email + Password fields
  // ═══════════════════════════════════════════════════════════════
  Widget _buildEmailFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => _clearErrors(),
          style: const TextStyle(
            fontSize: 16, color: textBlack, fontFamily: 'Inter', fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'alam.tania@gmmmail.ai',
            hintStyle: TextStyle(color: textGrey.withValues(alpha: 0.5), fontWeight: FontWeight.w400),
            filled: true,
            fillColor: bgWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: _inputBorder(borderGrey),
            enabledBorder: _inputBorder(_emailError != null ? Colors.red : borderGrey),
            focusedBorder: _inputBorder(_emailError != null ? Colors.red : textBlack, width: 1.5),
          ),
        ),
        if (_emailError != null) _buildErrorText(_emailError!),

        const SizedBox(height: 16),

        // Password
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (_) => _clearErrors(),
          style: const TextStyle(
            fontSize: 16, color: textBlack, fontFamily: 'Inter', fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: textGrey.withValues(alpha: 0.5), fontWeight: FontWeight.w400),
            filled: true,
            fillColor: bgWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: _inputBorder(borderGrey),
            enabledBorder: _inputBorder(_passwordError != null ? Colors.red : borderGrey),
            focusedBorder: _inputBorder(_passwordError != null ? Colors.red : textBlack, width: 1.5),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: textGrey,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        if (_passwordError != null) _buildErrorText(_passwordError!),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // WIDGET: Social login button (full width, icon + text)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: borderGrey, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: bgWhite,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════
  OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildErrorText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
