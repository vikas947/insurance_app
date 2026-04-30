import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_layout.dart';
import '../widgets/terms_text.dart';
import '../../../shared/widgets/app_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = TextEditingController();

  bool get isValid => controller.text.length == 6;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "We’ve sent a 6-digit code to your number",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 30),

          /// OTP INPUT (BOX STYLE)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45,
                child: TextField(
                  controller: controller,
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && index < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                    setState(() {});
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: 30),

          /// RESEND
          Row(
            children: const [
              Text("Didn’t receive OTP? "),
              Text(
                "Resend",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),

          const SizedBox(height: 30),

          /// BUTTON
          AppButton(
            text: "Verify OTP",
            enabled: isValid,
            onTap: () {
              Navigator.pushNamed(context, '/password');
            },
          ),
        ],
      ),
      pinnedBottom: const TermsText(),
    );
  }
}
