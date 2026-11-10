import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://6af20c0d42c6561ced38f2c2.mockapi.io',
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
