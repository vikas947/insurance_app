import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
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
  int _tabIndex = 1; // default Email
  bool _loading = false;

  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String? _emailError;
  String? _mobileError;

  bool get isMobile => _tabIndex == 0;

  bool get isValid {
    if (_loading) return false;

    if (isMobile) {
      return _mobileCtrl.text.replaceAll(' ', '').length == 10;
    } else {
      return _emailCtrl.text.trim().isNotEmpty;
    }
  }

  @override
  void initState() {
    super.initState();
    _mobileCtrl.addListener(() => setState(() {}));
    _emailCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  bool _validEmail(String email) {
    return RegExp(r'^[\w\.\-\+]+@[\w\-]+\.\w{2,}$').hasMatch(email);
  }

  Future<void> _handleCTA() async {
    if (!isValid) return;

    if (!isMobile && !_validEmail(_emailCtrl.text.trim())) {
      setState(() => _emailError = "Enter valid email");
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _loading = false);

    if (!mounted) return;

    if (isMobile) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(mobile: "+91 ${_mobileCtrl.text}"),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PasswordScreen(email: _emailCtrl.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      pinnedBottom: const TermsText(),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔥 IMPORTANT
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 🔹 TAB SWITCH
          TabSwitcher(
            tabs: const ["Mobile Number", "Email Address"],
            currentIndex: _tabIndex,
            onTabChanged: (i) => setState(() => _tabIndex = i),
          ),

          const SizedBox(height: 24),

          /// 🔹 INPUT
          isMobile ? _mobileInput() : _emailInput(),

          const SizedBox(height: 20),

          /// 🔹 CTA BUTTON
          PrimaryButton(
            text: isMobile ? "Verify with OTP" : "Enter Password",
            isLoading: _loading,
            onPressed: isValid ? _handleCTA : null,
          ),

          const SizedBox(height: 28),

          /// 🔹 DIVIDER
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.lightGrey)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Or login with",
                  style: TextStyle(fontSize: 13, color: AppColors.grey),
                ),
              ),
              Expanded(child: Divider(color: AppColors.lightGrey)),
            ],
          ),

          const SizedBox(height: 20),

          _socialBtn("Continue with Google"),
          const SizedBox(height: 12),
          _socialBtn("Continue with Facebook"),
        ],
      ),
    );
  }

  /// 🔹 MOBILE INPUT
  Widget _mobileInput() {
    return InputField(
      controller: _mobileCtrl,
      hintText: "Enter Mobile Number",
      keyboardType: TextInputType.number,
      errorText: _mobileError,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "🇮🇳 +91",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  /// 🔹 EMAIL INPUT
  Widget _emailInput() {
    return InputField(
      controller: _emailCtrl,
      hintText: "Enter Email Address",
      keyboardType: TextInputType.emailAddress,
      errorText: _emailError,
    );
  }

  /// 🔹 SOCIAL BTN
  Widget _socialBtn(String text) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
