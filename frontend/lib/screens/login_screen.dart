import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../services/auth_service.dart';
import '../services/local_storage.dart';
import '../widgets/auth_layout.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/tab_switcher.dart';
import '../widgets/terms_text.dart';
import 'otp_screen.dart';
import 'password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _currentTabIndex = 1; // 0 for Mobile, 1 for Email (default)
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  // GoogleSignIn is now a singleton in version 7.0+
  g_auth.GoogleSignIn get _googleSignIn => g_auth.GoogleSignIn.instance;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String? _emailError;
  String? _mobileError;

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_onInputChanged);
    _emailController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (_emailError != null || _mobileError != null) {
      setState(() {
        _emailError = null;
        _mobileError = null;
      });
    } else {
      setState(() {});
    }
  }

  bool get _isMobile => _currentTabIndex == 0;

  bool get _isCtaEnabled {
    if (_isLoading) return false;
    if (_isMobile) {
      return _mobileController.text.replaceAll(' ', '').length == 10;
    } else {
      return _emailController.text.trim().isNotEmpty;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.\-\+]+@[\w\-]+\.\w{2,}$').hasMatch(email);
  }

  Future<void> _handleCta() async {
    if (!_isCtaEnabled) return;

    if (!_isMobile && !_isValidEmail(_emailController.text.trim())) {
      setState(() => _emailError = "Please enter a valid email address");
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (_isMobile) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(mobile: '+91 ${_mobileController.text}')));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordScreen(email: _emailController.text.trim())));
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isGoogleLoading = true);
      
      await _googleSignIn.initialize();
      final g_auth.GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: <String>['email', 'profile'],
      );

      final response = await AuthService.socialLogin(
        loginType: 'google',
        email: googleUser.email,
        name: googleUser.displayName ?? 'Google User',
        providerId: googleUser.id,
      );

      if (!mounted) return;
      await _processAuthSuccess(response);

    } catch (e) {
      debugPrint('[Login] Google Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Login failed: $e'))
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      setState(() => _isFacebookLoading = true);
      
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        
        final response = await AuthService.socialLogin(
          loginType: 'facebook',
          email: userData['email'] ?? '',
          name: userData['name'] ?? 'Facebook User',
          providerId: userData['id'] ?? '',
        );

        if (!mounted) return;
        await _processAuthSuccess(response);
      }
    } catch (e) {
      debugPrint('[Login] Facebook Error: $e');
    } finally {
      if (mounted) setState(() => _isFacebookLoading = false);
    }
  }

  Future<void> _processAuthSuccess(Map<String, dynamic> response) async {
    if (response['token'] != null) {
      await LocalStorage.setToken(response['token']);
      // Navigate to home or dashboard
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        // Navigator.pushAndRemoveUntil(...)
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
          TabSwitcher(
            tabs: const ["Mobile Number", "Email Address"],
            currentIndex: _currentTabIndex,
            onTabChanged: (index) => setState(() => _currentTabIndex = index),
          ),
          const SizedBox(height: 24),
          if (_isMobile) _buildMobileInput() else _buildEmailInput(),
          const SizedBox(height: 22),
          PrimaryButton(
            text: _isMobile ? "Verify with OTP" : "Enter Password",
            isLoading: _isLoading,
            onPressed: _isCtaEnabled ? _handleCta : null,
          ),
          const SizedBox(height: 32),
          _buildDivider(),
          const SizedBox(height: 22),
          _buildSocialButton('assets/icons/google.png', "Continue with Google", _isGoogleLoading, _handleGoogleSignIn),
          const SizedBox(height: 14),
          _buildSocialButton('assets/icons/facebook.png', "Continue with Facebook", _isFacebookLoading, _handleFacebookSignIn),
        ],
      ),
    );
  }

  Widget _buildMobileInput() {
    return InputField(
      controller: _mobileController,
      hintText: "Enter Mobile Number",
      keyboardType: TextInputType.number,
      errorText: _mobileError,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        _PhoneNumberFormatter()
      ],
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🇮🇳 +91", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.black)
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return InputField(
      controller: _emailController,
      hintText: "Enter Email Address",
      keyboardType: TextInputType.emailAddress,
      errorText: _emailError,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.lightGrey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12), 
          child: Text("Or login with", style: TextStyle(fontSize: 13, color: AppColors.grey))
        ),
        Expanded(child: Divider(color: AppColors.lightGrey)),
      ],
    );
  }

  Widget _buildSocialButton(String icon, String text, bool isLoading, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.lightGrey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.inputRadius)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon, height: 22, width: 22, errorBuilder: (_, __, ___) => const Icon(Icons.login)),
                const SizedBox(width: 12),
                Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.black)),
              ],
            ),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    if (digits.length > 10) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}
