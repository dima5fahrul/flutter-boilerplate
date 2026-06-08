import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

class StorageService {
  final FlutterSecureStorage _storage;

  const StorageService(this._storage);

  Future<void> saveToken(String token) =>
      _storage.write(key: StorageKeys.token, value: token);

  Future<String?> getToken() =>
      _storage.read(key: StorageKeys.token);

  Future<void> deleteToken() =>
      _storage.delete(key: StorageKeys.token);
}
