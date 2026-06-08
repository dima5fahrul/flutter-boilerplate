class ServerException implements Exception {}

class ClientException implements Exception {
  final String message;
  const ClientException(this.message);
}

class CacheException implements Exception {}
