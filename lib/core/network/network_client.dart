abstract class NetworkClient {
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  });

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  });
}
