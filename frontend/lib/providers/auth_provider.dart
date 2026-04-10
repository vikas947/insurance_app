import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../services/auth_service.dart';
import '../services/local_storage.dart';
import '../services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isInitializing = true;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userProfile;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;

  // ── Google Sign-In instance ──
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // ════════════════════════════════════════════════════════════════
  // AUTO LOGIN: Check saved session on app start
  // ════════════════════════════════════════════════════════════════
  Future<void> checkAuthStatus() async {
    _isInitializing = true;
    notifyListeners();
    try {
      final hasSession = await LocalStorage.hasValidSession();
      debugPrint('[AuthProvider] hasValidSession: $hasSession');

      if (hasSession) {
        _isAuthenticated = true;
        // Try to fetch fresh profile; fall back to saved data
        try {
          _userProfile = await UserService.getProfile();
        } catch (e) {
          debugPrint('[AuthProvider] Profile fetch failed (using cached): $e');
          _userProfile = {
            'name': await LocalStorage.getUserName() ?? 'User',
            'email': await LocalStorage.getUserEmail() ?? '',
          };
        }
      }
    } catch (e) {
      debugPrint('[AuthProvider] checkAuthStatus error: $e');
      _isAuthenticated = false;
      await LocalStorage.clearSession();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  // ════════════════════════════════════════════════════════════════
  // MOBILE OTP FLOW
  // ════════════════════════════════════════════════════════════════
  Future<bool> sendOtp(String mobile) async {
    _setLoading(true);
    _errorMessage = null;
    bool success = false;
    try {
      final response = await AuthService.sendOtp(mobile);
      debugPrint('[AuthProvider] sendOtp response: $response');
      success = true;
    } catch (e) {
      debugPrint('[AuthProvider] sendOtp error: $e');
      _errorMessage = e.toString();
      // DEV FALLBACK: Allow OTP screen navigation even when backend is down
      // REMOVE THIS LINE IN PRODUCTION
      success = true;
    } finally {
      _setLoading(false);
    }
    return success;
  }

  Future<bool> verifyOtp(String mobile, String otp) async {
    _setLoading(true);
    _errorMessage = null;
    bool success = false;
    try {
      final response = await AuthService.verifyOtp(mobile, otp);
      debugPrint('[AuthProvider] verifyOtp response: $response');
      success = await _handleAuthResponse(response, loginType: 'mobile');
    } catch (e) {
      debugPrint('[AuthProvider] verifyOtp error: $e');
      _errorMessage = 'OTP verification failed. Please try again.';
    } finally {
      _setLoading(false);
    }
    return success;
  }

  // ════════════════════════════════════════════════════════════════
  // EMAIL LOGIN FLOW
  // ════════════════════════════════════════════════════════════════
  Future<bool> loginEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    bool success = false;
    try {
      final response = await AuthService.loginEmail(email, password);
      debugPrint('[AuthProvider] loginEmail response: $response');
      success = await _handleAuthResponse(response, loginType: 'email');
    } catch (e) {
      debugPrint('[AuthProvider] loginEmail error: $e');
      _errorMessage = 'Invalid credentials. Please try again.';
    } finally {
      _setLoading(false);
    }
    return success;
  }

  // ════════════════════════════════════════════════════════════════
  // GOOGLE SIGN-IN
  // ════════════════════════════════════════════════════════════════
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    bool success = false;
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        debugPrint('[AuthProvider] Google sign-in cancelled by user');
        _errorMessage = 'Google sign-in was cancelled';
        _setLoading(false);
        return false;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      final String? accessToken = auth.accessToken;
      final String token = idToken ?? accessToken ?? '';

      debugPrint('[AuthProvider] Google token acquired, sending to backend...');

      if (token.isEmpty) {
        _errorMessage = 'Failed to get Google credentials';
        _setLoading(false);
        return false;
      }

      try {
        final response = await AuthService.socialLogin('google', token);
        debugPrint('[AuthProvider] Google socialLogin response: $response');
        success = await _handleAuthResponse(response, loginType: 'google');
      } catch (e) {
        debugPrint('[AuthProvider] Google backend call failed: $e');
        _errorMessage = 'Google login failed. Please try again.';
      }
    } catch (e) {
      debugPrint('[AuthProvider] Google sign-in error: $e');
      _errorMessage = 'Google sign-in failed: ${e.toString()}';
      _setLoading(false);
      return false;
    } finally {
      if (_isLoading) _setLoading(false);
    }
    return success;
  }

  // ════════════════════════════════════════════════════════════════
  // FACEBOOK SIGN-IN
  // ════════════════════════════════════════════════════════════════
  Future<bool> signInWithFacebook() async {
    _setLoading(true);
    _errorMessage = null;
    bool success = false;
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) {
        debugPrint('[AuthProvider] Facebook login cancelled');
        _errorMessage = 'Facebook login was cancelled';
        _setLoading(false);
        return false;
      }

      if (result.status != LoginStatus.success || result.accessToken == null) {
        debugPrint('[AuthProvider] Facebook login failed: ${result.message}');
        _errorMessage = result.message ?? 'Facebook login failed';
        _setLoading(false);
        return false;
      }

      final String token = result.accessToken!.tokenString;
      debugPrint('[AuthProvider] Facebook token acquired, sending to backend...');

      try {
        final response = await AuthService.socialLogin('facebook', token);
        debugPrint('[AuthProvider] Facebook socialLogin response: $response');
        success = await _handleAuthResponse(response, loginType: 'facebook');
      } catch (e) {
        debugPrint('[AuthProvider] Facebook backend call failed: $e');
        _errorMessage = 'Facebook login failed. Please try again.';
      }
    } catch (e) {
      debugPrint('[AuthProvider] Facebook sign-in error: $e');
      _errorMessage = 'Facebook sign-in failed: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
    return success;
  }

  // ════════════════════════════════════════════════════════════════
  // LOGOUT
  // ════════════════════════════════════════════════════════════════
  Future<void> logout() async {
    _setLoading(true);
    try {
      // Sign out from social providers
      try { await _googleSignIn.signOut(); } catch (_) {}
      try { await FacebookAuth.instance.logOut(); } catch (_) {}

      await LocalStorage.clearSession();
      _isAuthenticated = false;
      _userProfile = null;
    } finally {
      _setLoading(false);
    }
  }

  // ════════════════════════════════════════════════════════════════
  // SHARED: Process auth response from any login method
  // ════════════════════════════════════════════════════════════════
  Future<bool> _handleAuthResponse(Map<String, dynamic> response, {required String loginType}) async {
    final token = response['token'];
    final user = response['user'] as Map<String, dynamic>?;

    if (token == null) {
      debugPrint('[AuthProvider] No token in response');
      _errorMessage = 'Authentication failed — no token received';
      return false;
    }

    final userId = user != null ? (user['_id'] ?? user['id'] ?? '') : '';
    final userName = user?['name'] ?? '';
    final userEmail = user?['email'] ?? '';

    await LocalStorage.saveSession(
      token: token,
      userId: userId.toString(),
      loginType: loginType,
      userName: userName.toString(),
      userEmail: userEmail.toString(),
    );

    _isAuthenticated = true;
    _userProfile = user ?? {'name': userName, 'email': userEmail};
    debugPrint('[AuthProvider] Auth success — user=$userId loginType=$loginType');
    return true;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
