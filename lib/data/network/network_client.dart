import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trembit_test_app/data/network/auth_interceptor.dart';

final _baseUrl = 'https://api.themoviedb.org/3/';

final networkClient = NetworkClient._(dio: Dio(), baseUrl: _baseUrl);

class NetworkClient {
  static const _connectTimeout = 5000; // millis
  static const _receiveTimeout = 20000; // millis

  final Dio dio;

  NetworkClient._({@required this.dio, @required String baseUrl}) {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
    );

    dio.interceptors
      ..add(
        AuthInterceptor(),
      )
      ..add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
  }

  static String buildImageUrl(String path) {
    assert(path != null);
    return '$_baseUrl$path';
  }
}
