import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'local_storage.dart';

class ApiClient {
  // Backend URL — update for production
  static const String baseUrl = 'http://10.0.2.2:5000'; // Android emulator → host machine
  // static const String baseUrl = 'http://127.0.0.1:5000'; // iOS simulator
  // static const String baseUrl = 'https://your-api.com'; // Production

  static Future<Map<String, String>> _getHeaders() async {
    final token = await LocalStorage.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint('[ApiClient] GET $uri');
    try {
      final response = await http.get(uri, headers: await _getHeaders())
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] GET error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint('[ApiClient] POST $uri body=$body');
    try {
      final response = await http.post(
        uri,
        headers: await _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] POST error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint('[ApiClient] PUT $uri body=$body');
    try {
      final response = await http.put(
        uri,
        headers: await _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] PUT error: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    debugPrint('[ApiClient] Response ${response.statusCode}: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      String errorMessage = 'Something went wrong';
      try {
        final decodedError = jsonDecode(response.body);
        if (decodedError['message'] != null) {
          errorMessage = decodedError['message'];
        }
      } catch (_) {}

      throw ApiException(message: errorMessage, statusCode: response.statusCode);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
