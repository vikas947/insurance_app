import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? userProfile = {'name': 'Demo User', 'email': 'demo@example.com'};

  Future<void> checkAuthStatus() async {}

  Future<void> logout() async {}

  Future<bool> sendOtp(String mobile) async {
    try {
      isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1)); // mock API

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = "OTP failed";
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String mobile, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == "123456"; // demo
  }
}
