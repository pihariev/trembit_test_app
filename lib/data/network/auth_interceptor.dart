import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  static const _apiKey = 'b6be45f4322112ef44554be9e0a0ab44';

  @override
  onRequest(RequestOptions options) {
    options.queryParameters['api_key'] = _apiKey;
  }
}
