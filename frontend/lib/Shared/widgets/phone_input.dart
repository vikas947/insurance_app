import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const PhoneInput({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// 🇮🇳 FLAG
          Image.asset(
            'assets/icons/india.png',
            width: 26,
            height: 18,
            fit: BoxFit.cover,
          ),

          const SizedBox(width: 8),

          /// +91
          const Text(
            "+91",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 10),

          /// VERTICAL DIVIDER
          Container(
            width: 1,
            height: 24,
            color: AppColors.border,
          ),

          const SizedBox(width: 10),

          /// INPUT
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                counterText: "",
                hintText: "Enter Mobile Number",
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
