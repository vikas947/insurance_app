import 'package:flutter/material.dart';

class AppColors {
  // ── Brand ──
  static const primary = Color(0xFF7B1E1E);
  static const primaryLight = Color(0xFFFBECEC);
  static const secondary = Color(0xFF0F3D8F);

  // ── Text ──
  static const textPrimary = Color(0xFF1C1C1C);
  static const textSecondary = Color(0xFF6B6B6B);

  // ── Surface / Background ──
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFF7F7F7);
  static const surfaceVariant = Color(0xFFF0F0F0);
  static const white = Colors.white;
  static const black = Colors.black;

  // ── Border / Divider ──
  static const border = Color(0xFFD0D0D0);
  static const divider = Color(0xFFE0E0E0);

  // ── Grey ──
  static const grey = Colors.grey;
  static const lightGrey = Color(0xFFE0E0E0);

  // ── State ──
  static const error = Colors.red;
  static const success = Color(0xFF2E7D32);
  static const successBg = Color(0xFFE8F5E9);
  static const warning = Color(0xFFEF6C00);
  static const warningBg = Color(0xFFFFF3E0);
  static const disabled = Color(0xFFBDBDBD);

  // ── Accent ──
  static const accent = Color(0xFFFF6B35);
  static const accentLight = Color(0xFFFFF0EB);

  // ── Policy type colors ──
  static const healthPolicy = Color(0xFF2E7D32);
  static const lifePolicy = Color(0xFF1565C0);
  static const vehiclePolicy = Color(0xFFEF6C00);

  // ── Helpers ──
  static Color getPolicyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'health':
        return healthPolicy;
      case 'life':
        return lifePolicy;
      case 'vehicle':
        return vehiclePolicy;
      default:
        return primary;
    }
  }

  static IconData getPolicyTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'health':
        return Icons.favorite_outline;
      case 'life':
        return Icons.person_outline;
      case 'vehicle':
        return Icons.directions_car_outlined;
      default:
        return Icons.shield_outlined;
    }
  }
}
