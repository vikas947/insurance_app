import 'package:flutter/material.dart';
import '../core/app_theme.dart';


class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isUnderlined;
  final IconData? icon;
  final bool isDisabled;
  final double fontSize;

  const LinkText({
    super.key,
    required this.text,
    this.onTap,
    this.isUnderlined = false,
    this.icon,
    this.isDisabled = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDisabled ? AppColors.disabled : AppColors.primary;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
              decoration: isUnderlined ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }
}
