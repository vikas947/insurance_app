import 'package:flutter/material.dart';
import 'api_client.dart';

/// Clean API adapter layer for all auth endpoints.
/// UI never calls ApiClient directly — always goes through this service.
class AuthService {
  /// Send OTP to a mobile number
  static Future<Map<String, dynamic>> sendOtp(String mobile) async {
    debugPrint('[AuthService] sendOtp($mobile)');
    return await ApiClient.post('/auth/send-otp', body: {'mobile': mobile});
  }

  /// Verify OTP and get JWT token
  static Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    debugPrint('[AuthService] verifyOtp($mobile, $otp)');
    return await ApiClient.post('/auth/verify-otp', body: {
      'mobile': mobile,
      'otp': otp,
    });
  }

  /// Email + password login
  static Future<Map<String, dynamic>> loginEmail(String email, String password) async {
    debugPrint('[AuthService] loginEmail($email)');
    return await ApiClient.post('/auth/login-email', body: {
      'email': email,
      'password': password,
    });
  }

  /// Social login (google / facebook)
  static Future<Map<String, dynamic>> socialLogin({
    required String loginType,
    required String email,
    required String name,
    required String providerId,
  }) async {
    debugPrint('[AuthService] socialLogin($loginType: $email)');
    return await ApiClient.post('/auth/social-login', body: {
      'loginType': loginType,
      'email': email,
      'name': name,
      'providerId': providerId,
    });
  }
}
