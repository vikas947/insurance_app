import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _kTokenKey = 'jwt_token';
  static const String _kUserIdKey = 'user_id';
  static const String _kLoginTypeKey = 'login_type';
  static const String _kUserNameKey = 'user_name';
  static const String _kUserEmailKey = 'user_email';

  /// Save full session after successful login/signup
  static Future<void> saveSession({
    required String token,
    required String userId,
    String? loginType,
    String? userName,
    String? userEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
    await prefs.setString(_kUserIdKey, userId);
    if (loginType != null) {
      await prefs.setString(_kLoginTypeKey, loginType);
    }
    if (userName != null) {
      await prefs.setString(_kUserNameKey, userName);
    }
    if (userEmail != null) {
      await prefs.setString(_kUserEmailKey, userEmail);
    }
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTokenKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserIdKey);
  }

  static Future<String?> getLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLoginTypeKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserNameKey);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserEmailKey);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kUserIdKey);
    await prefs.remove(_kLoginTypeKey);
    await prefs.remove(_kUserNameKey);
    await prefs.remove(_kUserEmailKey);
  }

  static Future<bool> hasValidSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
