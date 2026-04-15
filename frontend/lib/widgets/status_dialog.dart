import 'package:flutter/material.dart';
import 'package:frontend/core/app_theme.dart';
import '../widgets/primary_button.dart';

class StatusDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData? icon;
  final String? assetIcon;
  final Color iconColor;
  final bool isError;

  const StatusDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.icon,
    this.assetIcon,
    this.iconColor = Colors.red,
    this.isError = true,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData? icon,
    String? assetIcon,
    Color iconColor = Colors.red,
    bool isError = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatusDialog(
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        icon: icon,
        assetIcon: assetIcon,
        iconColor: iconColor,
        isError: isError,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 20, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (assetIcon != null)
            Image.asset(assetIcon!,
                height: 80,
                width: 80,
                errorBuilder: (_, __, ___) => Icon(icon ?? Icons.info_outline,
                    size: 80, color: iconColor))
          else
            Icon(
                icon ??
                    (isError
                        ? Icons.error_outline
                        : Icons.check_circle_outline),
                size: 80,
                color: iconColor),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 14, color: Colors.grey.shade600, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (buttonText != null)
            PrimaryButton(
              text: buttonText!,
              onPressed: onButtonPressed ?? () => Navigator.pop(context),
            ),
          const SizedBox(height: 16),
          if (!isError)
            TextButton(
              onPressed: () {},
              child: const Text("Resend Email",
                  style: TextStyle(
                      color: AppColors.ctaEnabled,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
