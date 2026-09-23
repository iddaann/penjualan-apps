import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => message;
}

class ApiClient {
  static Uri _buildUri(String path, [Map<String, String>? queryParams]) {
    return Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: queryParams);
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<dynamic> get(String path, {Map<String, String>? query}) async {
    try {
      final response = await http.get(_buildUri(path, query), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Server terlalu lama merespons.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Tidak dapat terhubung ke server: $e');
    }
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(_buildUri(path), headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Server terlalu lama merespons.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Tidak dapat terhubung ke server: $e');
    }
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.put(_buildUri(path), headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Server terlalu lama merespons.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Tidak dapat terhubung ke server: $e');
    }
  }

  static Future<dynamic> delete(String path) async {
    try {
      final response = await http.delete(_buildUri(path), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Server terlalu lama merespons.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Tidak dapat terhubung ke server: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    var message = 'Terjadi kesalahan (status ${response.statusCode})';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['error'] != null) {
        message = decoded['error'].toString();
      }
    } catch (_) {}

    throw ApiException(message, statusCode: response.statusCode);
  }
}
