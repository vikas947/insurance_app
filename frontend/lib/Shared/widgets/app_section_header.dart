import 'package:flutter/material.dart';

/// Reusable section header with optional action label.
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1C),
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B6B6B),
            ),
          ),
      ],
    );
  }
}
