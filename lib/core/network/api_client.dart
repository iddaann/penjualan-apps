import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Exception khusus untuk error dari API, supaya repository bisa
/// menangkap pesan error yang jelas (bukan cuma exception generic).
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Wrapper tipis di atas package:http, supaya semua repository tidak
/// perlu mengulang logic parsing response & error handling sendiri-sendiri.
class ApiClient {
  static Uri _buildUri(String path, [Map<String, String>? queryParams]) {
    return Uri.parse('${ApiConfig.baseUrl}$path').replace(
      queryParameters: queryParams,
    );
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  static Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final response = await http.get(_buildUri(path, query), headers: _headers);
    return _handleResponse(response);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      _buildUri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      _buildUri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> delete(String path) async {
    final response = await http.delete(_buildUri(path), headers: _headers);
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    // Coba ambil pesan error dari body JSON backend (format {"error": "..."})
    String message = 'Terjadi kesalahan (status $statusCode)';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['error'] != null) {
        message = decoded['error'].toString();
      }
    } catch (_) {
      // body bukan JSON valid, pakai pesan default di atas
    }

    throw ApiException(message, statusCode: statusCode);
  }
}