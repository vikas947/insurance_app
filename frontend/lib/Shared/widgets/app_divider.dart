import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        const SizedBox(width: 10),
        const Text(
          "Or login with",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
