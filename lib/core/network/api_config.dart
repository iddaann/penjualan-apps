class ApiConfig {
  ApiConfig._();

  /// Override saat build/deploy:
  /// flutter build apk --release --dart-define=API_BASE_URL=https://your-api.example.com/api
  /// Android emulator lokal menggunakan 10.0.2.2 untuk host machine.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api',
  );
}
