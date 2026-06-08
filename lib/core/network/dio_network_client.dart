import 'package:dio/dio.dart';
import '../constant/api_endpoint.dart';
import '../error/exception.dart';
import 'network_client.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${ApiEndpoint.accessToken}';
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }
}

class DioNetworkClient implements NetworkClient {
  final Dio dio;

  DioNetworkClient({required this.dio});

  @override
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParams,
      );
      return response.data!;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        endpoint,
        data: body,
      );
      return response.data!;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Exception _mapError(DioException e) {
    final status = e.response?.statusCode;
    if (status != null && status >= 500) return ServerException();
    return ClientException(
      (e.response?.data as Map<String, dynamic>?)?['status_message']
              as String? ??
          e.message ??
          'Client error',
    );
  }
}

Dio buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoint.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  );
  dio.interceptors.add(AuthInterceptor());
  return dio;
}
