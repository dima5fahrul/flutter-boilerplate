import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../core/network/dio_network_client.dart';
import '../../../core/network/http_network_client.dart';
import '../../../core/network/network_client.dart';
import '../../../core/storage/storage_keys.dart';
import '../data/datasources/movie_detail_remote_datasource.dart';
import '../data/datasources/movie_list_remote_datasource.dart';
import '../data/datasources/movie_local_datasource.dart';
import 'movie_injection.dart';

class MovieDatasourceInjection {
  static Future<void> inject() async {
    final movieBox = await Hive.openBox<String>(StorageKeys.movieBox);

    movieInjection
      ..registerLazySingleton<Dio>(() => buildDio())
      ..registerLazySingleton<NetworkClient>(
        () => HttpNetworkClient(client: http.Client()),
        instanceName: 'http',
      )
      ..registerLazySingleton<NetworkClient>(
        () => DioNetworkClient(dio: movieInjection<Dio>()),
        instanceName: 'dio',
      )
      ..registerLazySingleton<MovieListRemoteDatasource>(
        () => MovieListRemoteDatasourceImpl(
              client: movieInjection<NetworkClient>(instanceName: 'http'),
            ),
      )
      ..registerLazySingleton<MovieDetailRemoteDatasource>(
        () => MovieDetailRemoteDatasourceImpl(
              client: movieInjection<NetworkClient>(instanceName: 'dio'),
            ),
      )
      ..registerLazySingleton<MovieLocalDatasource>(
        () => MovieLocalDatasourceImpl(movieBox: movieBox),
      );
  }
}
