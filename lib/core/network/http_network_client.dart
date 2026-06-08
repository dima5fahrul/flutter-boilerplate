import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/api_endpoint.dart';
import '../error/exception.dart';
import 'network_client.dart';

class HttpNetworkClient implements NetworkClient {
  final http.Client client;

  const HttpNetworkClient({required this.client});

  @override
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse(endpoint).replace(
      queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())),
    );
    final response = await client.get(uri, headers: _headers());
    return _handleResponse(response);
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(endpoint);
    final response = await client.post(
      uri,
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 500) throw ServerException();
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw ClientException(decoded['status_message'] ?? 'Client error');
    }
    return decoded;
  }

  Map<String, String> _headers() => {
        'Authorization': 'Bearer ${ApiEndpoint.accessToken}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
