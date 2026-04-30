import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_layout.dart';
import '../widgets/terms_text.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final controller = TextEditingController();
  bool obscure = true;

  bool get isValid => controller.text.length >= 6;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Enter Password",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          /// INPUT
          Stack(
            alignment: Alignment.centerRight,
            children: [
              AppInput(
                controller: controller,
                hint: "Enter Password",
                obscureText: obscure,
                onChanged: (_) => setState(() {}),
              ),
              IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => obscure = !obscure);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// FORGOT
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// BUTTON
          AppButton(
            text: "Login",
            enabled: isValid,
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
        ],
      ),
      pinnedBottom: const TermsText(),
    );
  }
}
