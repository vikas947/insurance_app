import 'package:flutter/material.dart';
import 'api_client.dart';

class UserService {
  /// Get current user profile
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiClient.get('/user/profile');
    debugPrint('[UserService] getProfile response keys: ${response.keys}');
    // Handle { user: {...} } or direct map
    if (response['user'] is Map) return response['user'];
    return response;
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await ApiClient.put('/user/update-profile', body: data);
  }

  /// Upload document
  static Future<Map<String, dynamic>> uploadDoc() async {
    return await ApiClient.post('/user/upload-doc');
  }
}
