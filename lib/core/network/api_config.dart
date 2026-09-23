import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  /// Override saat build/deploy:
  /// flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080/api
  /// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
  /// flutter build apk --release --dart-define=API_BASE_URL=https://your-api.example.com/api
  static const String _configuredBaseUrl =
      String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }

    return 'http://10.0.2.2:8080/api';
  }
}
