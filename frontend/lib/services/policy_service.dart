import 'package:flutter/material.dart';
import 'api_client.dart';

class PolicyService {
  /// Get all user policies — backend returns { policies: [...] }
  static Future<List<dynamic>> getUserPolicies() async {
    try {
      final response = await ApiClient.get('/policy');
      debugPrint('[PolicyService] getUserPolicies response keys: ${response.keys}');
      // Handle both: direct list in 'policies' key, or 'data' key
      if (response['policies'] is List) return response['policies'];
      if (response['data'] is List) return response['data'];
      return [];
    } catch (e) {
      debugPrint('[PolicyService] getUserPolicies error: $e');
      return [];
    }
  }

  /// Get recommended policies
  static Future<List<dynamic>> getRecommendations() async {
    try {
      final response = await ApiClient.get('/policy/recommendations');
      debugPrint('[PolicyService] getRecommendations response keys: ${response.keys}');
      if (response['recommendations'] is List) return response['recommendations'];
      if (response['data'] is List) return response['data'];
      return [];
    } catch (e) {
      debugPrint('[PolicyService] getRecommendations error: $e');
      return [];
    }
  }

  /// Get single policy by ID
  static Future<Map<String, dynamic>> getPolicyById(String id) async {
    final response = await ApiClient.get('/policy/$id');
    // Could be { policy: {...} } or direct map
    if (response['policy'] is Map) return response['policy'];
    return response;
  }

  /// Buy a policy
  static Future<Map<String, dynamic>> buyPolicy(Map<String, dynamic> policyData) async {
    return await ApiClient.post('/policy/buy', body: policyData);
  }
}
