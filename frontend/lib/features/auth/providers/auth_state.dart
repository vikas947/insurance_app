import 'package:flutter/material.dart';

class AuthState {
  static ValueNotifier<String> phone = ValueNotifier("");
  static ValueNotifier<String> email = ValueNotifier("");
  static ValueNotifier<String> otp = ValueNotifier("");
}
