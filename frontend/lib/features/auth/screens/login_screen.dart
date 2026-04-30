import 'package:flutter/material.dart';

import '../widgets/auth_layout.dart';
import '../widgets/tab_switcher.dart';
import '../widgets/phone_input.dart';
import '../widgets/social_button.dart';
import '../widgets/terms_text.dart';

import '../../../Shared/widgets/app_button.dart';
import '../../../Shared/widgets/app_input.dart';
import '../../../Shared/widgets/app_divider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isMobile = true;

  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool get isValid {
    if (!isMobile) {
      return emailController.text.trim().isNotEmpty;
    } else {
      return phoneController.text.trim().length >= 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔴 TOGGLE (Mobile / Email)
          TabSwitcher(
            isMobile: isMobile,
            onChange: (value) {
              setState(() => isMobile = value);
            },
          ),

          const SizedBox(height: 20),

          /// 🔴 INPUT
          isMobile
              ? PhoneInput(
                  controller: phoneController,
                  onChanged: () => setState(() {}),
                )
              : AppInput(
                  controller: emailController,
                  hint: "Enter Email Address",
                  onChanged: (_) => setState(() {}),
                ),

          const SizedBox(height: 20),

          /// 🔴 CTA BUTTON
          AppButton(
            text: isMobile ? "Verify with OTP" : "Enter Password",
            enabled: isValid,
            onTap: () {
              if (!isValid) return;

              if (!isMobile) {
                Navigator.pushNamed(context, '/password');
              } else {
                Navigator.pushNamed(context, '/otp');
              }
            },
          ),

          const SizedBox(height: 24),

          /// 🔴 DIVIDER
          const AppDivider(),

          const SizedBox(height: 20),

          /// 🔴 SOCIAL BUTTONS
          const SocialButton(text: "Continue with Google"),
          const SizedBox(height: 12),
          const SocialButton(text: "Continue with Facebook"),

          const SizedBox(height: 30),
        ],
      ),

      /// 🔴 BOTTOM TERMS
      pinnedBottom: const TermsText(),
    );
  }
}
