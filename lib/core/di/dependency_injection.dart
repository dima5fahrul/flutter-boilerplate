import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../storage/storage_service.dart';
import '../../features/movie/di/movie_feature_injection.dart';

final injection = GetIt.instance;

class DependencyInjection {
  Future<void> init() async {
    injection.registerLazySingleton<StorageService>(
      () => const StorageService(FlutterSecureStorage()),
    );
    await MovieFeatureInjection.init();
  }
}
