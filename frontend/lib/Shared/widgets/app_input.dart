import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const AppInput({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
