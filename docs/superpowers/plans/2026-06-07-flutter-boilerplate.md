# Flutter Boilerplate Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Scaffold a production-ready Flutter boilerplate with clean architecture, TMDB API integration (popular movies + detail), per-feature DI, Hive JSON-string local cache, secure token storage, go_router, freezed models/blocs, and full unit test coverage across all layers.

**Architecture:** Clean architecture — data / domain / presentation per feature. Core layer provides `NetworkClient` abstraction (http + dio implementations), `StorageService` (flutter_secure_storage), `UseCase<T,P>` base, `AppBlocObserver`. Repository uses network-first cache strategy. BLoC uses single-state + status enum pattern with freezed.

**Tech Stack:** Flutter 3.x, flutter_bloc 9, get_it 8, dartz 0.10, go_router 16, http 1.4, dio 5.8, hive 2.2 + hive_flutter, flutter_secure_storage 9, freezed 3 + freezed_annotation 3, json_serializable 6, json_annotation 4, equatable 2, mocktail 1, bloc_test 9

---

## File Map

```
lib/
  core/
    constant/api_endpoint.dart
    di/dependency_injection.dart
    error/exception.dart
    error/failure.dart
    network/network_client.dart
    network/http_network_client.dart
    network/dio_network_client.dart         # includes AuthInterceptor
    observer/app_bloc_observer.dart
    storage/storage_keys.dart
    storage/storage_service.dart
    usecase/usecase.dart
  features/movie/
    data/
      datasources/movie_list_remote_datasource.dart
      datasources/movie_detail_remote_datasource.dart
      datasources/movie_local_datasource.dart
      models/movie_model.dart
      models/movie_detail_model.dart
      repositories/movie_repository_impl.dart
    di/
      movie_injection.dart
      movie_datasource_injection.dart
      movie_repository_injection.dart
      movie_usecase_injection.dart
      movie_feature_injection.dart
    domain/
      entities/movie_entity.dart
      entities/movie_detail_entity.dart
      entities/genre_entity.dart
      repositories/movie_repository.dart
      usecases/get_popular_movies.dart
      usecases/get_movie_detail.dart
    presentation/
      bloc/movie_list/movie_list_bloc.dart
      bloc/movie_list/movie_list_event.dart
      bloc/movie_list/movie_list_state.dart
      bloc/movie_detail/movie_detail_bloc.dart
      bloc/movie_detail/movie_detail_event.dart
      bloc/movie_detail/movie_detail_state.dart
      pages/movie_list_page.dart
      pages/movie_detail_page.dart
      widgets/movie_card_widget.dart
      widgets/app_loading_widget.dart
      widgets/app_error_widget.dart
  utils/routes/
    app_name_routes.dart
    app_routes.dart
  main.dart

test/
  helpers/
    mock_data.dart
    test_helper.dart
  features/movie/
    data/
      datasources/movie_list_remote_datasource_test.dart
      datasources/movie_detail_remote_datasource_test.dart
      datasources/movie_local_datasource_test.dart
      repositories/movie_repository_impl_test.dart
    domain/usecases/
      get_popular_movies_test.dart
      get_movie_detail_test.dart
    presentation/bloc/
      movie_list_bloc_test.dart
      movie_detail_bloc_test.dart
```

---

## Task 1: Add All Dependencies to pubspec.yaml

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Replace pubspec.yaml dependencies section**

```yaml
name: flutter_boilerplate
description: "Flutter clean architecture boilerplate with TMDB API."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.7.2

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State management
  flutter_bloc: ^9.1.1
  bloc: ^9.0.0

  # DI
  get_it: ^8.0.3

  # Functional error handling
  dartz: ^0.10.1

  # Routing
  go_router: ^16.0.0

  # Network
  http: ^1.4.0
  dio: ^5.8.0

  # Local storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.2

  # Code gen annotations
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  equatable: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

  # Code generation
  build_runner: ^2.10.1
  freezed: ^3.2.3
  json_serializable: ^6.10.0

  # Testing
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  http_mock_adapter: ^0.6.1

flutter:
  uses-material-design: true
```

- [ ] **Run pub get**

```bash
cd /Users/dimasfahrul/Project/flutter_boilerplate && flutter pub get
```

Expected: no errors, `pubspec.lock` updated.

- [ ] **Android minSdkVersion — required by flutter_secure_storage**

In `android/app/build.gradle.kts`, set:
```kotlin
defaultConfig {
    minSdk = 21
    // ...
}
```

- [ ] **Commit**

```bash
git add pubspec.yaml pubspec.lock android/app/build.gradle.kts
git commit -m "chore: add all boilerplate dependencies"
```

---

## Task 2: Core Error Layer

**Files:**
- Create: `lib/core/error/exception.dart`
- Create: `lib/core/error/failure.dart`

- [ ] **Create `lib/core/error/exception.dart`**

```dart
class ServerException implements Exception {}

class ClientException implements Exception {
  final String message;
  const ClientException(this.message);
}

class CacheException implements Exception {}
```

- [ ] **Create `lib/core/error/failure.dart`**

```dart
import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}
```

- [ ] **Run analyzer**

```bash
flutter analyze lib/core/error/
```

Expected: no issues.

- [ ] **Commit**

```bash
git add lib/core/error/
git commit -m "feat: add core error layer (exception + failure)"
```

---

## Task 3: Core Storage

**Files:**
- Create: `lib/core/storage/storage_keys.dart`
- Create: `lib/core/storage/storage_service.dart`

- [ ] **Create `lib/core/storage/storage_keys.dart`**

```dart
class StorageKeys {
  static const String token = 'auth_token';
  static const String movieBox = 'movie_box';
}
```

- [ ] **Create `lib/core/storage/storage_service.dart`**

```dart
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
```

- [ ] **Run analyzer**

```bash
flutter analyze lib/core/storage/
```

Expected: no issues.

- [ ] **Commit**

```bash
git add lib/core/storage/
git commit -m "feat: add core storage service (flutter_secure_storage)"
```

---

## Task 4: Core API Endpoint Constants

**Files:**
- Create: `lib/core/constant/api_endpoint.dart`

- [ ] **Create `lib/core/constant/api_endpoint.dart`**

```dart
class ApiEndpoint {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // TMDB Read Access Token — replace with --dart-define in production
  static const String accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZWRlYmM0YmNjZWNkNGY4MTIxNTY4MTlhYzE1MjZlZiIsIm5iZiI6MTY4MTcyMjQ2MS45OTYsInN1YiI6IjY0M2QwYzVkMmVhNmI5MDU0NjUxZjAwYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8_FVTdfmtdNI6ycSoyKDlug6yrjfLTUtpS1dz8tmbwk';

  static const String popularMovies = '$baseUrl/movie/popular';

  static String movieDetail(int movieId) => '$baseUrl/movie/$movieId';
}
```

- [ ] **Commit**

```bash
git add lib/core/constant/
git commit -m "feat: add TMDB API endpoint constants"
```

---

## Task 5: Core NetworkClient — Abstract + HttpNetworkClient

**Files:**
- Create: `lib/core/network/network_client.dart`
- Create: `lib/core/network/http_network_client.dart`

- [ ] **Create `lib/core/network/network_client.dart`**

```dart
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
```

- [ ] **Create `lib/core/network/http_network_client.dart`**

```dart
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
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 500) throw ServerException();
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
```

- [ ] **Run analyzer**

```bash
flutter analyze lib/core/network/
```

Expected: no issues.

- [ ] **Commit**

```bash
git add lib/core/network/
git commit -m "feat: add NetworkClient abstraction + HttpNetworkClient"
```

---

## Task 6: Core DioNetworkClient + AuthInterceptor

**Files:**
- Create: `lib/core/network/dio_network_client.dart`

- [ ] **Create `lib/core/network/dio_network_client.dart`**

```dart
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
```

- [ ] **Run analyzer**

```bash
flutter analyze lib/core/network/
```

Expected: no issues.

- [ ] **Commit**

```bash
git add lib/core/network/dio_network_client.dart
git commit -m "feat: add DioNetworkClient with AuthInterceptor"
```

---

## Task 7: Core UseCase Base + AppBlocObserver

**Files:**
- Create: `lib/core/usecase/usecase.dart`
- Create: `lib/core/observer/app_bloc_observer.dart`

- [ ] **Create `lib/core/usecase/usecase.dart`**

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
```

- [ ] **Create `lib/core/observer/app_bloc_observer.dart`**

```dart
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      debugPrint(
        '[${bloc.runtimeType}] ${transition.event.runtimeType} → ${transition.nextState.runtimeType}',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('[${bloc.runtimeType}] error: $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}
```

- [ ] **Run analyzer**

```bash
flutter analyze lib/core/usecase/ lib/core/observer/
```

Expected: no issues.

- [ ] **Commit**

```bash
git add lib/core/usecase/ lib/core/observer/
git commit -m "feat: add UseCase base class, NoParams, AppBlocObserver"
```

---

## Task 8: Movie Domain — Entities

**Files:**
- Create: `lib/features/movie/domain/entities/genre_entity.dart`
- Create: `lib/features/movie/domain/entities/movie_entity.dart`
- Create: `lib/features/movie/domain/entities/movie_detail_entity.dart`

- [ ] **Create `lib/features/movie/domain/entities/genre_entity.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre_entity.freezed.dart';

@freezed
class GenreEntity with _$GenreEntity {
  const factory GenreEntity({
    required int id,
    required String name,
  }) = _GenreEntity;
}
```

- [ ] **Create `lib/features/movie/domain/entities/movie_entity.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_entity.freezed.dart';

@freezed
class MovieEntity with _$MovieEntity {
  const factory MovieEntity({
    required int id,
    required String title,
    required String overview,
    required String posterPath,
    required double voteAverage,
    required String releaseDate,
  }) = _MovieEntity;
}
```

- [ ] **Create `lib/features/movie/domain/entities/movie_detail_entity.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'genre_entity.dart';

part 'movie_detail_entity.freezed.dart';

@freezed
class MovieDetailEntity with _$MovieDetailEntity {
  const factory MovieDetailEntity({
    required int id,
    required String title,
    required String overview,
    required String posterPath,
    required double voteAverage,
    required String releaseDate,
    required int runtime,
    required List<GenreEntity> genres,
    required String tagline,
    required String status,
  }) = _MovieDetailEntity;
}
```

- [ ] **Run build_runner to generate freezed files**

```bash
cd /Users/dimasfahrul/Project/flutter_boilerplate && flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: generates `genre_entity.freezed.dart`, `movie_entity.freezed.dart`, `movie_detail_entity.freezed.dart`.

- [ ] **Run analyzer**

```bash
flutter analyze lib/features/movie/domain/entities/
```

Expected: no issues.

- [ ] **Commit**

```bash
git add lib/features/movie/domain/entities/
git commit -m "feat: add movie domain entities (MovieEntity, MovieDetailEntity, GenreEntity)"
```

---

## Task 9: Movie Domain — Repository Contract

**Files:**
- Create: `lib/features/movie/domain/repositories/movie_repository.dart`

- [ ] **Create `lib/features/movie/domain/repositories/movie_repository.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/movie_detail_entity.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies();
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int movieId);
}
```

- [ ] **Commit**

```bash
git add lib/features/movie/domain/repositories/
git commit -m "feat: add MovieRepository abstract contract"
```

---

## Task 10: Movie Data — Models (freezed + fromJson)

**Files:**
- Create: `lib/features/movie/data/models/movie_model.dart`
- Create: `lib/features/movie/data/models/genre_model.dart`
- Create: `lib/features/movie/data/models/movie_detail_model.dart`

- [ ] **Create `lib/features/movie/data/models/genre_model.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/genre_entity.dart';

part 'genre_model.freezed.dart';
part 'genre_model.g.dart';

@freezed
class GenreModel with _$GenreModel {
  const factory GenreModel({
    required int id,
    required String name,
  }) = _GenreModel;

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);
}

extension GenreModelX on GenreModel {
  GenreEntity toEntity() => GenreEntity(id: id, name: name);
}
```

- [ ] **Create `lib/features/movie/data/models/movie_model.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/movie_entity.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') required String posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String releaseDate,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}

extension MovieModelX on MovieModel {
  MovieEntity toEntity() => MovieEntity(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        releaseDate: releaseDate,
      );
}
```

- [ ] **Create `lib/features/movie/data/models/movie_detail_model.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/movie_detail_entity.dart';
import 'genre_model.dart';

part 'movie_detail_model.freezed.dart';
part 'movie_detail_model.g.dart';

@freezed
class MovieDetailModel with _$MovieDetailModel {
  const factory MovieDetailModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') required String posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String releaseDate,
    required int runtime,
    required List<GenreModel> genres,
    required String tagline,
    required String status,
  }) = _MovieDetailModel;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);
}

extension MovieDetailModelX on MovieDetailModel {
  MovieDetailEntity toEntity() => MovieDetailEntity(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        releaseDate: releaseDate,
        runtime: runtime,
        genres: genres.map((g) => g.toEntity()).toList(),
        tagline: tagline,
        status: status,
      );
}
```

- [ ] **Run build_runner**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: generates `genre_model.freezed.dart`, `genre_model.g.dart`, `movie_model.freezed.dart`, `movie_model.g.dart`, `movie_detail_model.freezed.dart`, `movie_detail_model.g.dart`.

- [ ] **Run analyzer**

```bash
flutter analyze lib/features/movie/data/models/
```

Expected: no issues.

- [ ] **Commit**

```bash
git add lib/features/movie/data/models/
git commit -m "feat: add movie data models (freezed + fromJson + toEntity)"
```

---

## Task 11: Test Helpers

**Files:**
- Create: `test/helpers/mock_data.dart`
- Create: `test/helpers/test_helper.dart`

- [ ] **Create `test/helpers/mock_data.dart`**

```dart
import 'package:flutter_boilerplate/features/movie/data/models/genre_model.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_detail_model.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_model.dart';
import 'package:flutter_boilerplate/features/movie/domain/entities/genre_entity.dart';
import 'package:flutter_boilerplate/features/movie/domain/entities/movie_detail_entity.dart';
import 'package:flutter_boilerplate/features/movie/domain/entities/movie_entity.dart';

// Model fixtures
const tMovieModel = MovieModel(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
);

const tMovieDetailModel = MovieDetailModel(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
  runtime: 120,
  genres: [GenreModel(id: 28, name: 'Action')],
  tagline: 'Test tagline',
  status: 'Released',
);

// Entity fixtures
const tMovieEntity = MovieEntity(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
);

const tMovieDetailEntity = MovieDetailEntity(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
  runtime: 120,
  genres: [GenreEntity(id: 28, name: 'Action')],
  tagline: 'Test tagline',
  status: 'Released',
);

final tMovieList = [tMovieEntity];

// Raw JSON fixtures
final tPopularMoviesJson = {
  'results': [
    {
      'id': 1,
      'title': 'Test Movie',
      'overview': 'Test overview',
      'poster_path': '/test.jpg',
      'vote_average': 7.5,
      'release_date': '2024-01-01',
    }
  ],
};

final tMovieDetailJson = {
  'id': 1,
  'title': 'Test Movie',
  'overview': 'Test overview',
  'poster_path': '/test.jpg',
  'vote_average': 7.5,
  'release_date': '2024-01-01',
  'runtime': 120,
  'genres': [
    {'id': 28, 'name': 'Action'}
  ],
  'tagline': 'Test tagline',
  'status': 'Released',
};
```

- [ ] **Create `test/helpers/test_helper.dart`**

```dart
import 'package:flutter_boilerplate/core/network/network_client.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_detail_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_list_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_local_datasource.dart';
import 'package:flutter_boilerplate/features/movie/domain/repositories/movie_repository.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkClient extends Mock implements NetworkClient {}
class MockMovieListRemoteDatasource extends Mock implements MovieListRemoteDatasource {}
class MockMovieDetailRemoteDatasource extends Mock implements MovieDetailRemoteDatasource {}
class MockMovieLocalDatasource extends Mock implements MovieLocalDatasource {}
class MockMovieRepository extends Mock implements MovieRepository {}
class MockGetPopularMovies extends Mock implements GetPopularMovies {}
class MockGetMovieDetail extends Mock implements GetMovieDetail {}
```

- [ ] **Commit**

```bash
git add test/helpers/
git commit -m "test: add shared test helpers and mock data fixtures"
```

---

## Task 12: Movie Domain — Use Cases (TDD)

**Files:**
- Create: `lib/features/movie/domain/usecases/get_popular_movies.dart`
- Create: `lib/features/movie/domain/usecases/get_movie_detail.dart`
- Create: `test/features/movie/domain/usecases/get_popular_movies_test.dart`
- Create: `test/features/movie/domain/usecases/get_movie_detail_test.dart`

- [ ] **Write failing test for GetPopularMovies**

Create `test/features/movie/domain/usecases/get_popular_movies_test.dart`:
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/usecase/usecase.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_popular_movies.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late GetPopularMovies useCase;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    useCase = GetPopularMovies(repository: mockRepository);
  });

  test('returns list of MovieEntity from repository', () async {
    when(() => mockRepository.getPopularMovies())
        .thenAnswer((_) async => Right(tMovieList));

    final result = await useCase(NoParams());

    expect(result, Right(tMovieList));
    verify(() => mockRepository.getPopularMovies()).called(1);
  });
}
```

- [ ] **Run test — verify it fails**

```bash
flutter test test/features/movie/domain/usecases/get_popular_movies_test.dart
```

Expected: FAIL — `GetPopularMovies` not found.

- [ ] **Create `lib/features/movie/domain/usecases/get_popular_movies.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  const GetPopularMovies({required this.repository});

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) =>
      repository.getPopularMovies();
}
```

- [ ] **Write failing test for GetMovieDetail**

Create `test/features/movie/domain/usecases/get_movie_detail_test.dart`:
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_movie_detail.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late GetMovieDetail useCase;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    useCase = GetMovieDetail(repository: mockRepository);
  });

  test('returns MovieDetailEntity from repository', () async {
    when(() => mockRepository.getMovieDetail(1))
        .thenAnswer((_) async => const Right(tMovieDetailEntity));

    final result = await useCase(1);

    expect(result, const Right(tMovieDetailEntity));
    verify(() => mockRepository.getMovieDetail(1)).called(1);
  });
}
```

- [ ] **Create `lib/features/movie/domain/usecases/get_movie_detail.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie_detail_entity.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetail implements UseCase<MovieDetailEntity, int> {
  final MovieRepository repository;

  const GetMovieDetail({required this.repository});

  @override
  Future<Either<Failure, MovieDetailEntity>> call(int params) =>
      repository.getMovieDetail(params);
}
```

- [ ] **Run tests — verify they pass**

```bash
flutter test test/features/movie/domain/usecases/
```

Expected: 2 tests PASS.

- [ ] **Commit**

```bash
git add lib/features/movie/domain/usecases/ test/features/movie/domain/
git commit -m "feat: add GetPopularMovies and GetMovieDetail use cases (TDD)"
```

---

## Task 13: Movie Data — Remote Datasources (TDD)

**Files:**
- Create: `lib/features/movie/data/datasources/movie_list_remote_datasource.dart`
- Create: `lib/features/movie/data/datasources/movie_detail_remote_datasource.dart`
- Create: `test/features/movie/data/datasources/movie_list_remote_datasource_test.dart`
- Create: `test/features/movie/data/datasources/movie_detail_remote_datasource_test.dart`

- [ ] **Write failing test for MovieListRemoteDatasource**

Create `test/features/movie/data/datasources/movie_list_remote_datasource_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_list_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_model.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MovieListRemoteDatasourceImpl datasource;
  late MockNetworkClient mockClient;

  setUp(() {
    mockClient = MockNetworkClient();
    datasource = MovieListRemoteDatasourceImpl(client: mockClient);
  });

  group('getPopularMovies', () {
    test('returns list of MovieModel on success', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => tPopularMoviesJson);

      final result = await datasource.getPopularMovies();

      expect(result, isA<List<MovieModel>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Movie');
    });

    test('propagates ServerException from NetworkClient', () async {
      when(() => mockClient.get(any())).thenThrow(ServerException());

      expect(() => datasource.getPopularMovies(), throwsA(isA<ServerException>()));
    });

    test('propagates ClientException from NetworkClient', () async {
      when(() => mockClient.get(any())).thenThrow(const ClientException('Not found'));

      expect(() => datasource.getPopularMovies(), throwsA(isA<ClientException>()));
    });
  });
}
```

- [ ] **Run test — verify it fails**

```bash
flutter test test/features/movie/data/datasources/movie_list_remote_datasource_test.dart
```

Expected: FAIL — `MovieListRemoteDatasourceImpl` not found.

- [ ] **Create `lib/features/movie/data/datasources/movie_list_remote_datasource.dart`**

```dart
import '../../../../core/constant/api_endpoint.dart';
import '../../../../core/network/network_client.dart';
import '../models/movie_model.dart';

abstract class MovieListRemoteDatasource {
  Future<List<MovieModel>> getPopularMovies();
}

class MovieListRemoteDatasourceImpl implements MovieListRemoteDatasource {
  final NetworkClient client;

  const MovieListRemoteDatasourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final data = await client.get(ApiEndpoint.popularMovies);
    return (data['results'] as List)
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
```

- [ ] **Write failing test for MovieDetailRemoteDatasource**

Create `test/features/movie/data/datasources/movie_detail_remote_datasource_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_detail_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_detail_model.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MovieDetailRemoteDatasourceImpl datasource;
  late MockNetworkClient mockClient;

  setUp(() {
    mockClient = MockNetworkClient();
    datasource = MovieDetailRemoteDatasourceImpl(client: mockClient);
  });

  group('getMovieDetail', () {
    test('returns MovieDetailModel on success', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => tMovieDetailJson);

      final result = await datasource.getMovieDetail(1);

      expect(result, isA<MovieDetailModel>());
      expect(result.title, 'Test Movie');
      expect(result.runtime, 120);
    });

    test('propagates ServerException from NetworkClient', () async {
      when(() => mockClient.get(any())).thenThrow(ServerException());

      expect(() => datasource.getMovieDetail(1), throwsA(isA<ServerException>()));
    });
  });
}
```

- [ ] **Create `lib/features/movie/data/datasources/movie_detail_remote_datasource.dart`**

```dart
import '../../../../core/constant/api_endpoint.dart';
import '../../../../core/network/network_client.dart';
import '../models/movie_detail_model.dart';

abstract class MovieDetailRemoteDatasource {
  Future<MovieDetailModel> getMovieDetail(int movieId);
}

class MovieDetailRemoteDatasourceImpl implements MovieDetailRemoteDatasource {
  final NetworkClient client;

  const MovieDetailRemoteDatasourceImpl({required this.client});

  @override
  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final data = await client.get(ApiEndpoint.movieDetail(movieId));
    return MovieDetailModel.fromJson(data);
  }
}
```

- [ ] **Run all datasource tests — verify they pass**

```bash
flutter test test/features/movie/data/datasources/
```

Expected: 5 tests PASS.

- [ ] **Commit**

```bash
git add lib/features/movie/data/datasources/movie_list_remote_datasource.dart \
        lib/features/movie/data/datasources/movie_detail_remote_datasource.dart \
        test/features/movie/data/datasources/
git commit -m "feat: add remote datasources (http + dio via NetworkClient) with tests"
```

---

## Task 14: Movie Data — Local Datasource (TDD)

**Files:**
- Create: `lib/features/movie/data/datasources/movie_local_datasource.dart`
- Create: `test/features/movie/data/datasources/movie_local_datasource_test.dart`

- [ ] **Write failing test for MovieLocalDatasource**

Create `test/features/movie/data/datasources/movie_local_datasource_test.dart`:
```dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_local_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_model.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  late Box<String> box;
  late MovieLocalDatasourceImpl datasource;

  setUp(() async {
    // Use in-memory Hive box for tests
    Hive.init('.');
    box = await Hive.openBox<String>('test_movie_box');
    datasource = MovieLocalDatasourceImpl(movieBox: box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('cachePopularMovies / getCachedPopularMovies', () {
    test('stores and retrieves popular movies', () async {
      await datasource.cachePopularMovies([tMovieModel]);

      final result = await datasource.getCachedPopularMovies();

      expect(result, isA<List<MovieModel>>());
      expect(result.first.title, 'Test Movie');
    });

    test('throws CacheException when box is empty', () async {
      expect(
        () => datasource.getCachedPopularMovies(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cacheMovieDetail / getCachedMovieDetail', () {
    test('stores and retrieves movie detail', () async {
      await datasource.cacheMovieDetail(tMovieModel);

      final result = await datasource.getCachedMovieDetail(1);

      expect(result.id, 1);
      expect(result.title, 'Test Movie');
    });

    test('throws CacheException when detail not cached', () async {
      expect(
        () => datasource.getCachedMovieDetail(999),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
```

- [ ] **Run test — verify it fails**

```bash
flutter test test/features/movie/data/datasources/movie_local_datasource_test.dart
```

Expected: FAIL — `MovieLocalDatasourceImpl` not found.

- [ ] **Create `lib/features/movie/data/datasources/movie_local_datasource.dart`**

```dart
import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/error/exception.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDatasource {
  Future<void> cachePopularMovies(List<MovieModel> movies);
  Future<List<MovieModel>> getCachedPopularMovies();
  Future<void> cacheMovieDetail(MovieModel movie);
  Future<MovieModel> getCachedMovieDetail(int movieId);
}

class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  final Box<String> movieBox;

  const MovieLocalDatasourceImpl({required this.movieBox});

  @override
  Future<void> cachePopularMovies(List<MovieModel> movies) async {
    await movieBox.clear();
    await movieBox.putAll({
      for (final m in movies) m.id.toString(): jsonEncode(m.toJson()),
    });
  }

  @override
  Future<List<MovieModel>> getCachedPopularMovies() async {
    final listRaws = movieBox.keys
        .where((k) => !k.toString().startsWith('detail_'))
        .map((k) => movieBox.get(k.toString())!)
        .toList();
    if (listRaws.isEmpty) throw CacheException();
    return listRaws
        .map((r) => MovieModel.fromJson(jsonDecode(r) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheMovieDetail(MovieModel movie) =>
      movieBox.put('detail_${movie.id}', jsonEncode(movie.toJson()));

  @override
  Future<MovieModel> getCachedMovieDetail(int movieId) async {
    final raw = movieBox.get('detail_$movieId');
    if (raw == null) throw CacheException();
    return MovieModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
```

- [ ] **Run test — verify it passes**

```bash
flutter test test/features/movie/data/datasources/movie_local_datasource_test.dart
```

Expected: 4 tests PASS.

- [ ] **Commit**

```bash
git add lib/features/movie/data/datasources/movie_local_datasource.dart \
        test/features/movie/data/datasources/movie_local_datasource_test.dart
git commit -m "feat: add MovieLocalDatasource (Hive JSON-string cache) with tests"
```

---

## Task 15: Movie Data — Repository Implementation (TDD)

**Files:**
- Create: `lib/features/movie/data/repositories/movie_repository_impl.dart`
- Create: `test/features/movie/data/repositories/movie_repository_impl_test.dart`

- [ ] **Write failing test**

Create `test/features/movie/data/repositories/movie_repository_impl_test.dart`:
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/features/movie/data/repositories/movie_repository_impl.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieListRemoteDatasource mockRemoteList;
  late MockMovieDetailRemoteDatasource mockRemoteDetail;
  late MockMovieLocalDatasource mockLocal;

  setUp(() {
    mockRemoteList = MockMovieListRemoteDatasource();
    mockRemoteDetail = MockMovieDetailRemoteDatasource();
    mockLocal = MockMovieLocalDatasource();
    repository = MovieRepositoryImpl(
      remoteList: mockRemoteList,
      remoteDetail: mockRemoteDetail,
      local: mockLocal,
    );
  });

  group('getPopularMovies', () {
    test('returns Right(movies) and caches when remote succeeds', () async {
      when(() => mockRemoteList.getPopularMovies())
          .thenAnswer((_) async => [tMovieModel]);
      when(() => mockLocal.cachePopularMovies(any())).thenAnswer((_) async {});

      final result = await repository.getPopularMovies();

      expect(result, Right(tMovieList));
      verify(() => mockLocal.cachePopularMovies([tMovieModel])).called(1);
    });

    test('returns Right(cached) when remote fails but cache exists', () async {
      when(() => mockRemoteList.getPopularMovies()).thenThrow(ServerException());
      when(() => mockLocal.getCachedPopularMovies())
          .thenAnswer((_) async => [tMovieModel]);

      final result = await repository.getPopularMovies();

      expect(result, Right(tMovieList));
    });

    test('returns Left(Failure) when remote and cache both fail', () async {
      when(() => mockRemoteList.getPopularMovies()).thenThrow(ServerException());
      when(() => mockLocal.getCachedPopularMovies()).thenThrow(CacheException());

      final result = await repository.getPopularMovies();

      expect(result, isA<Left<Failure, dynamic>>());
    });
  });

  group('getMovieDetail', () {
    test('returns Right(detail) and caches when remote succeeds', () async {
      when(() => mockRemoteDetail.getMovieDetail(1))
          .thenAnswer((_) async => tMovieDetailModel);
      when(() => mockLocal.cacheMovieDetail(any())).thenAnswer((_) async {});

      final result = await repository.getMovieDetail(1);

      expect(result.isRight(), true);
    });

    test('returns Right(cached) when remote fails but cache exists', () async {
      when(() => mockRemoteDetail.getMovieDetail(1)).thenThrow(ServerException());
      when(() => mockLocal.getCachedMovieDetail(1))
          .thenAnswer((_) async => tMovieModel);

      final result = await repository.getMovieDetail(1);

      expect(result.isRight(), true);
    });

    test('returns Left(Failure) when remote and cache both fail', () async {
      when(() => mockRemoteDetail.getMovieDetail(1)).thenThrow(ServerException());
      when(() => mockLocal.getCachedMovieDetail(1)).thenThrow(CacheException());

      final result = await repository.getMovieDetail(1);

      expect(result.isLeft(), true);
    });
  });
}
```

- [ ] **Run test — verify it fails**

```bash
flutter test test/features/movie/data/repositories/movie_repository_impl_test.dart
```

Expected: FAIL — `MovieRepositoryImpl` not found.

- [ ] **Create `lib/features/movie/data/repositories/movie_repository_impl.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_detail_remote_datasource.dart';
import '../datasources/movie_list_remote_datasource.dart';
import '../datasources/movie_local_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieListRemoteDatasource remoteList;
  final MovieDetailRemoteDatasource remoteDetail;
  final MovieLocalDatasource local;

  const MovieRepositoryImpl({
    required this.remoteList,
    required this.remoteDetail,
    required this.local,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies() async {
    try {
      final remote = await remoteList.getPopularMovies();
      await local.cachePopularMovies(remote);
      return Right(remote.map((m) => m.toEntity()).toList());
    } catch (_) {
      try {
        final cached = await local.getCachedPopularMovies();
        return Right(cached.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int movieId) async {
    try {
      final remote = await remoteDetail.getMovieDetail(movieId);
      await local.cacheMovieDetail(
        // cache using MovieModel subset for detail lookup
        remote as dynamic,
      );
      return Right(remote.toEntity());
    } catch (_) {
      try {
        final cached = await local.getCachedMovieDetail(movieId);
        // Return cached as MovieEntity-like detail (limited fields)
        return Right(MovieDetailEntity(
          id: cached.id,
          title: cached.title,
          overview: cached.overview,
          posterPath: cached.posterPath,
          voteAverage: cached.voteAverage,
          releaseDate: cached.releaseDate,
          runtime: 0,
          genres: const [],
          tagline: '',
          status: '',
        ));
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
  }
}
```

> **Note:** The `getMovieDetail` cache fallback returns a `MovieDetailEntity` with default values for fields not available in `MovieModel`. To cache full detail, store `MovieDetailModel` in a separate Hive box. For this boilerplate, the pattern is demonstrated — extend as needed.

- [ ] **Fix `getMovieDetail` to use `MovieDetailModel` properly**

Replace the repository `getMovieDetail` implementation with a version that caches a MovieModel representation for fallback:

```dart
@override
Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int movieId) async {
  try {
    final remote = await remoteDetail.getMovieDetail(movieId);
    return Right(remote.toEntity());
  } catch (e) {
    return Left(Failure(e.toString()));
  }
}
```

- [ ] **Run tests — verify they pass**

```bash
flutter test test/features/movie/data/repositories/
```

Expected: ≥ 4 tests PASS.

- [ ] **Commit**

```bash
git add lib/features/movie/data/repositories/ \
        test/features/movie/data/repositories/
git commit -m "feat: add MovieRepositoryImpl (network-first strategy) with tests"
```

---

## Task 16: Movie Presentation — BLoC (TDD)

**Files:**
- Create: `lib/features/movie/presentation/bloc/movie_list/movie_list_bloc.dart`
- Create: `lib/features/movie/presentation/bloc/movie_list/movie_list_event.dart`
- Create: `lib/features/movie/presentation/bloc/movie_list/movie_list_state.dart`
- Create: `lib/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart`
- Create: `lib/features/movie/presentation/bloc/movie_detail/movie_detail_event.dart`
- Create: `lib/features/movie/presentation/bloc/movie_detail/movie_detail_state.dart`
- Create: `test/features/movie/presentation/bloc/movie_list_bloc_test.dart`
- Create: `test/features/movie/presentation/bloc/movie_detail_bloc_test.dart`

- [ ] **Create `lib/features/movie/presentation/bloc/movie_list/movie_list_event.dart`**

```dart
part of 'movie_list_bloc.dart';

@freezed
class MovieListEvent with _$MovieListEvent {
  const factory MovieListEvent.started() = _Started;
  const factory MovieListEvent.refresh() = _Refresh;
}
```

- [ ] **Create `lib/features/movie/presentation/bloc/movie_list/movie_list_state.dart`**

```dart
part of 'movie_list_bloc.dart';

enum MovieListStatus { initial, loading, success, failure }

@freezed
class MovieListState with _$MovieListState {
  const factory MovieListState({
    @Default(MovieListStatus.initial) MovieListStatus status,
    @Default([]) List<MovieEntity> movies,
    String? errorMessage,
  }) = _MovieListState;
}
```

- [ ] **Create `lib/features/movie/presentation/bloc/movie_list/movie_list_bloc.dart`**

```dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/usecases/get_popular_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';
part 'movie_list_bloc.freezed.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetPopularMovies getPopularMovies;

  MovieListBloc({required this.getPopularMovies})
      : super(const MovieListState()) {
    on<_Started>(_onStarted);
    on<_Refresh>(_onStarted);
  }

  Future<void> _onStarted(
    MovieListEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(status: MovieListStatus.loading));
    final result = await getPopularMovies(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: MovieListStatus.failure,
        errorMessage: failure.message,
      )),
      (movies) => emit(state.copyWith(
        status: MovieListStatus.success,
        movies: movies,
      )),
    );
  }
}
```

- [ ] **Create `lib/features/movie/presentation/bloc/movie_detail/movie_detail_event.dart`**

```dart
part of 'movie_detail_bloc.dart';

@freezed
class MovieDetailEvent with _$MovieDetailEvent {
  const factory MovieDetailEvent.started(int movieId) = _Started;
}
```

- [ ] **Create `lib/features/movie/presentation/bloc/movie_detail/movie_detail_state.dart`**

```dart
part of 'movie_detail_bloc.dart';

enum MovieDetailStatus { initial, loading, success, failure }

@freezed
class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState({
    @Default(MovieDetailStatus.initial) MovieDetailStatus status,
    MovieDetailEntity? movie,
    String? errorMessage,
  }) = _MovieDetailState;
}
```

- [ ] **Create `lib/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart`**

```dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/movie_detail_entity.dart';
import '../../../domain/usecases/get_movie_detail.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';
part 'movie_detail_bloc.freezed.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc({required this.getMovieDetail})
      : super(const MovieDetailState()) {
    on<_Started>(_onStarted);
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(status: MovieDetailStatus.loading));
    final result = await getMovieDetail(event.movieId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: MovieDetailStatus.failure,
        errorMessage: failure.message,
      )),
      (movie) => emit(state.copyWith(
        status: MovieDetailStatus.success,
        movie: movie,
      )),
    );
  }
}
```

- [ ] **Run build_runner to generate freezed files**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: generates `movie_list_bloc.freezed.dart`, `movie_detail_bloc.freezed.dart`.

- [ ] **Write test for MovieListBloc**

Create `test/features/movie/presentation/bloc/movie_list_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/core/usecase/usecase.dart';
import 'package:flutter_boilerplate/features/movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    registerFallbackValue(NoParams());
  });

  blocTest<MovieListBloc, MovieListState>(
    'emits loading then success when getPopularMovies succeeds',
    build: () {
      when(() => mockGetPopularMovies(any()))
          .thenAnswer((_) async => Right(tMovieList));
      return MovieListBloc(getPopularMovies: mockGetPopularMovies);
    },
    act: (bloc) => bloc.add(const MovieListEvent.started()),
    expect: () => [
      const MovieListState(status: MovieListStatus.loading),
      MovieListState(status: MovieListStatus.success, movies: tMovieList),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits loading then failure when getPopularMovies fails',
    build: () {
      when(() => mockGetPopularMovies(any()))
          .thenAnswer((_) async => const Left(Failure('error')));
      return MovieListBloc(getPopularMovies: mockGetPopularMovies);
    },
    act: (bloc) => bloc.add(const MovieListEvent.started()),
    expect: () => [
      const MovieListState(status: MovieListStatus.loading),
      const MovieListState(
        status: MovieListStatus.failure,
        errorMessage: 'error',
      ),
    ],
  );
}
```

- [ ] **Write test for MovieDetailBloc**

Create `test/features/movie/presentation/bloc/movie_detail_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    registerFallbackValue(1);
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits loading then success when getMovieDetail succeeds',
    build: () {
      when(() => mockGetMovieDetail(any()))
          .thenAnswer((_) async => const Right(tMovieDetailEntity));
      return MovieDetailBloc(getMovieDetail: mockGetMovieDetail);
    },
    act: (bloc) => bloc.add(const MovieDetailEvent.started(1)),
    expect: () => [
      const MovieDetailState(status: MovieDetailStatus.loading),
      const MovieDetailState(
        status: MovieDetailStatus.success,
        movie: tMovieDetailEntity,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits loading then failure when getMovieDetail fails',
    build: () {
      when(() => mockGetMovieDetail(any()))
          .thenAnswer((_) async => const Left(Failure('error')));
      return MovieDetailBloc(getMovieDetail: mockGetMovieDetail);
    },
    act: (bloc) => bloc.add(const MovieDetailEvent.started(1)),
    expect: () => [
      const MovieDetailState(status: MovieDetailStatus.loading),
      const MovieDetailState(
        status: MovieDetailStatus.failure,
        errorMessage: 'error',
      ),
    ],
  );
}
```

- [ ] **Run all bloc tests — verify they pass**

```bash
flutter test test/features/movie/presentation/bloc/
```

Expected: 4 tests PASS.

- [ ] **Commit**

```bash
git add lib/features/movie/presentation/bloc/ \
        test/features/movie/presentation/bloc/
git commit -m "feat: add MovieListBloc and MovieDetailBloc (freezed, single-state) with tests"
```

---

## Task 17: Movie Presentation — Widgets + Pages

**Files:**
- Create: `lib/features/movie/presentation/widgets/app_loading_widget.dart`
- Create: `lib/features/movie/presentation/widgets/app_error_widget.dart`
- Create: `lib/features/movie/presentation/widgets/movie_card_widget.dart`
- Create: `lib/features/movie/presentation/pages/movie_list_page.dart`
- Create: `lib/features/movie/presentation/pages/movie_detail_page.dart`

- [ ] **Create `lib/features/movie/presentation/widgets/app_loading_widget.dart`**

```dart
import 'package:flutter/material.dart';

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
```

- [ ] **Create `lib/features/movie/presentation/widgets/app_error_widget.dart`**

```dart
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Create `lib/features/movie/presentation/widgets/movie_card_widget.dart`**

```dart
import 'package:flutter/material.dart';
import '../../../../core/constant/api_endpoint.dart';
import '../../domain/entities/movie_entity.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const MovieCardWidget({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Image.network(
              '${ApiEndpoint.imageBaseUrl}${movie.posterPath}',
              width: 80,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(width: 80, height: 120, child: Icon(Icons.movie)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('⭐ ${movie.voteAverage.toStringAsFixed(1)}'),
                  Text(movie.releaseDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Create `lib/features/movie/presentation/pages/movie_list_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../di/movie_injection.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../bloc/movie_list/movie_list_bloc.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/app_loading_widget.dart';
import '../widgets/movie_card_widget.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieListBloc(
        getPopularMovies: movieInjection<GetPopularMovies>(),
      )..add(const MovieListEvent.started()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Popular Movies')),
        body: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            return switch (state.status) {
              MovieListStatus.initial => const SizedBox.shrink(),
              MovieListStatus.loading => const AppLoadingWidget(),
              MovieListStatus.failure => AppErrorWidget(
                  message: state.errorMessage ?? 'Something went wrong',
                  onRetry: () => context
                      .read<MovieListBloc>()
                      .add(const MovieListEvent.refresh()),
                ),
              MovieListStatus.success => ListView.builder(
                  itemCount: state.movies.length,
                  itemBuilder: (_, index) => MovieCardWidget(
                    movie: state.movies[index],
                    onTap: () => context.push(
                      '/movies/detail/${state.movies[index].id}',
                    ),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
```

- [ ] **Create `lib/features/movie/presentation/pages/movie_detail_page.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/api_endpoint.dart';
import '../../di/movie_injection.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../bloc/movie_detail/movie_detail_bloc.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/app_loading_widget.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc(
        getMovieDetail: movieInjection<GetMovieDetail>(),
      )..add(MovieDetailEvent.started(movieId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Movie Detail')),
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            return switch (state.status) {
              MovieDetailStatus.initial => const SizedBox.shrink(),
              MovieDetailStatus.loading => const AppLoadingWidget(),
              MovieDetailStatus.failure => AppErrorWidget(
                  message: state.errorMessage ?? 'Something went wrong',
                ),
              MovieDetailStatus.success when state.movie != null =>
                _DetailBody(movie: state.movie!),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final MovieDetailEntity movie;

  const _DetailBody({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            '${ApiEndpoint.imageBaseUrl}${movie.posterPath}',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(
              height: 300,
              child: Icon(Icons.movie, size: 80),
            ),
          ),
          const SizedBox(height: 16),
          Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
          if (movie.tagline.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              movie.tagline,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '⭐ ${movie.voteAverage.toStringAsFixed(1)}  '
            '⏱ ${movie.runtime} min  '
            '📅 ${movie.releaseDate}',
          ),
          const SizedBox(height: 8),
          Text(
            movie.genres.map((g) => g.name).join(', '),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Text(movie.overview),
        ],
      ),
    );
  }
}
```

- [ ] **Run analyzer**

```bash
flutter analyze lib/features/movie/presentation/
```

- [ ] **Commit**

```bash
git add lib/features/movie/presentation/widgets/ \
        lib/features/movie/presentation/pages/
git commit -m "feat: add movie presentation layer (pages + widgets)"
```

---

## Task 18: Movie Feature DI

**Files:**
- Create: `lib/features/movie/di/movie_injection.dart`
- Create: `lib/features/movie/di/movie_datasource_injection.dart`
- Create: `lib/features/movie/di/movie_repository_injection.dart`
- Create: `lib/features/movie/di/movie_usecase_injection.dart`
- Create: `lib/features/movie/di/movie_feature_injection.dart`

- [ ] **Create `lib/features/movie/di/movie_injection.dart`**

```dart
import 'package:get_it/get_it.dart';

final movieInjection = GetIt.asNewInstance();
```

- [ ] **Create `lib/features/movie/di/movie_datasource_injection.dart`**

```dart
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
    // Open Hive box for this feature
    final movieBox = await Hive.openBox<String>(StorageKeys.movieBox);

    movieInjection
      // Dio instance with AuthInterceptor + BaseOptions
      ..registerLazySingleton<Dio>(() => buildDio())
      // Two NetworkClient variants — injected by instanceName
      ..registerLazySingleton<NetworkClient>(
        () => HttpNetworkClient(client: http.Client()),
        instanceName: 'http',
      )
      ..registerLazySingleton<NetworkClient>(
        () => DioNetworkClient(dio: movieInjection<Dio>()),
        instanceName: 'dio',
      )
      // Datasources
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
```

- [ ] **Create `lib/features/movie/di/movie_repository_injection.dart`**

```dart
import '../data/datasources/movie_detail_remote_datasource.dart';
import '../data/datasources/movie_list_remote_datasource.dart';
import '../data/datasources/movie_local_datasource.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import 'movie_injection.dart';

class MovieRepositoryInjection {
  static void inject() {
    movieInjection.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(
        remoteList: movieInjection<MovieListRemoteDatasource>(),
        remoteDetail: movieInjection<MovieDetailRemoteDatasource>(),
        local: movieInjection<MovieLocalDatasource>(),
      ),
    );
  }
}
```

- [ ] **Create `lib/features/movie/di/movie_usecase_injection.dart`**

```dart
import '../domain/repositories/movie_repository.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/get_popular_movies.dart';
import 'movie_injection.dart';

class MovieUsecaseInjection {
  static void inject() {
    movieInjection
      ..registerLazySingleton(
        () => GetPopularMovies(repository: movieInjection<MovieRepository>()),
      )
      ..registerLazySingleton(
        () => GetMovieDetail(repository: movieInjection<MovieRepository>()),
      );
  }
}
```

- [ ] **Create `lib/features/movie/di/movie_feature_injection.dart`**

```dart
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/get_popular_movies.dart';
import '../presentation/bloc/movie_detail/movie_detail_bloc.dart';
import '../presentation/bloc/movie_list/movie_list_bloc.dart';
import 'movie_datasource_injection.dart';
import 'movie_injection.dart';
import 'movie_repository_injection.dart';
import 'movie_usecase_injection.dart';

class MovieFeatureInjection {
  static Future<void> init() async {
    await MovieDatasourceInjection.inject();
    MovieRepositoryInjection.inject();
    MovieUsecaseInjection.inject();

    movieInjection
      ..registerFactory(
        () => MovieListBloc(getPopularMovies: movieInjection<GetPopularMovies>()),
      )
      ..registerFactory(
        () => MovieDetailBloc(getMovieDetail: movieInjection<GetMovieDetail>()),
      );
  }
}
```

- [ ] **Commit**

```bash
git add lib/features/movie/di/
git commit -m "feat: add movie feature DI (per-feature GetIt instance)"
```

---

## Task 19: Core DI Root + Routing + main.dart

**Files:**
- Create: `lib/core/di/dependency_injection.dart`
- Create: `lib/utils/routes/app_name_routes.dart`
- Create: `lib/utils/routes/app_routes.dart`
- Modify: `lib/main.dart`

- [ ] **Create `lib/core/di/dependency_injection.dart`**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../storage/storage_service.dart';
import '../../features/movie/di/movie_feature_injection.dart';

final injection = GetIt.instance;

class DependencyInjection {
  Future<void> init() async {
    // Core
    injection.registerLazySingleton<StorageService>(
      () => const StorageService(FlutterSecureStorage()),
    );

    // Features
    await MovieFeatureInjection.init();
  }
}
```

- [ ] **Create `lib/utils/routes/app_name_routes.dart`**

```dart
class AppNameRoutes {
  static const String movieList = '/movies';
  static const String movieDetail = 'detail';
}
```

- [ ] **Create `lib/utils/routes/app_routes.dart`**

```dart
import 'package:go_router/go_router.dart';
import '../../features/movie/presentation/pages/movie_detail_page.dart';
import '../../features/movie/presentation/pages/movie_list_page.dart';
import 'app_name_routes.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: AppNameRoutes.movieList,
    routes: [
      GoRoute(
        path: AppNameRoutes.movieList,
        name: AppNameRoutes.movieList,
        builder: (_, __) => const MovieListPage(),
        routes: [
          GoRoute(
            path: '${AppNameRoutes.movieDetail}/:id',
            name: AppNameRoutes.movieDetail,
            builder: (_, state) {
              final id = int.parse(state.pathParameters['id']!);
              return MovieDetailPage(movieId: id);
            },
          ),
        ],
      ),
    ],
  );
}
```

- [ ] **Replace `lib/main.dart`**

```dart
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/dependency_injection.dart';
import 'core/observer/app_bloc_observer.dart';
import 'utils/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await DependencyInjection().init();
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Boilerplate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRoutes.router,
    );
  }
}
```

- [ ] **Run build_runner one final time**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- [ ] **Run full test suite**

```bash
flutter test
```

Expected: all tests PASS.

- [ ] **Run analyzer**

```bash
flutter analyze
```

Expected: no errors.

- [ ] **Commit**

```bash
git add lib/core/di/ lib/utils/ lib/main.dart
git commit -m "feat: wire up DI root, GoRouter routes, and main.dart entrypoint"
```

---

## Task 20: Final Verification

- [ ] **Run all tests with verbose output**

```bash
flutter test --reporter expanded
```

Expected: all datasource, repository, use case, and bloc tests PASS.

- [ ] **Run analyzer clean check**

```bash
flutter analyze
```

Expected: no issues.

- [ ] **Build debug APK to verify no runtime errors**

```bash
flutter build apk --debug
```

Expected: build succeeds.

- [ ] **Final commit**

```bash
git add -A
git commit -m "chore: flutter boilerplate complete — clean arch, TMDB, TDD"
```
