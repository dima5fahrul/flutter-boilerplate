# Flutter Boilerplate — Design Spec

**Date:** 2026-06-07  
**Project:** flutter_boilerplate  
**Backend:** TMDB API (https://developer.themoviedb.org)  
**Reference:** sales_canvaser_mobile_apps

---

## 1. Goals

Create a Flutter boilerplate that demonstrates:
- Clean architecture (data / domain / presentation)
- Per-feature dependency injection
- Secure token storage + feature-level local cache
- Declarative routing
- Reactive state management with code-generated models
- Full unit test coverage across all layers

---

## 2. Architecture

**Pattern:** Clean Architecture — 3 layers per feature.

```
data       → talks to network + local storage, maps raw data to models
domain     → pure Dart business logic, entities, use cases, repository contracts
presentation → bloc, pages, widgets
```

Layers depend inward only: `presentation → domain ← data`

---

## 3. Package Stack

### Runtime dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^9.1.1 | BLoC state management |
| `bloc` | ^9.0.0 | BLoC core |
| `get_it` | ^8.0.3 | Dependency injection |
| `dartz` | ^0.10.1 | Functional `Either` for error handling |
| `go_router` | ^16.0.0 | Declarative routing |
| `http` | ^1.4.0 | Network client (movie list datasource) |
| `dio` | ^5.8.0 | Network client (movie detail datasource) |
| `hive` | ^2.2.3 | Feature-level local cache |
| `hive_flutter` | ^1.1.0 | Hive Flutter init |
| `flutter_secure_storage` | ^9.2.2 | Encrypted token storage |
| `freezed_annotation` | ^3.1.0 | Freezed annotation |
| `json_annotation` | ^4.9.0 | JSON serialization annotation |
| `equatable` | ^2.0.7 | NoParams equality |

### Dev dependencies

| Package | Version | Purpose |
|---|---|---|
| `build_runner` | ^2.10.1 | Code generation runner |
| `freezed` | ^3.2.3 | Freezed code generator |
| `json_serializable` | ^6.10.0 | JSON code generator |
| `hive_generator` | — | Not needed — cache uses JSON string, no TypeAdapter |
| `bloc_test` | ^9.1.7 | BLoC unit test helpers |
| `mocktail` | ^1.0.4 | Mock generation (no codegen) |
| `http_mock_adapter` | ^0.6.1 | Mock Dio client for tests |

---

## 4. Folder Structure

```
lib/
├── core/
│   ├── constant/
│   │   └── api_endpoint.dart          # TMDB base URL, endpoints, access token
│   ├── di/
│   │   └── dependency_injection.dart  # GetIt root — calls all feature injections
│   ├── error/
│   │   ├── exception.dart             # ServerException, ClientException, CacheException
│   │   └── failure.dart               # Failure(message) — dartz Either Left
│   ├── network/
│   │   ├── network_client.dart        # abstract NetworkClient interface
│   │   ├── http_network_client.dart   # http.Client impl — exception mapping here
│   │   └── dio_network_client.dart    # Dio impl + AuthInterceptor
│   ├── observer/
│   │   └── app_bloc_observer.dart     # BlocObserver — logs transitions + errors
│   └── storage/
│       ├── storage_keys.dart          # const keys for secure storage + hive box names
│       └── storage_service.dart       # flutter_secure_storage wrapper (token CRUD)
├── features/
│   └── movie/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── movie_list_remote_datasource.dart    # NetworkClient (http impl)
│       │   │   ├── movie_detail_remote_datasource.dart  # NetworkClient (dio impl)
│       │   │   └── movie_local_datasource.dart          # Hive Box<MovieModel>
│       │   ├── models/
│       │   │   ├── movie_model.dart         # @freezed + fromJson + @HiveType
│       │   │   └── movie_detail_model.dart  # @freezed + fromJson + @HiveType
│       │   └── repositories/
│       │       └── movie_repository_impl.dart  # network-first cache strategy
│       ├── di/
│       │   ├── movie_injection.dart               # GetIt instance for this feature
│       │   ├── movie_datasource_injection.dart    # register datasources
│       │   ├── movie_repository_injection.dart    # register repository
│       │   ├── movie_usecase_injection.dart       # register use cases
│       │   └── movie_feature_injection.dart       # register blocs (factory)
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── movie_entity.dart        # @freezed, no fromJson/toJson
│       │   │   └── movie_detail_entity.dart # @freezed, no fromJson/toJson
│       │   ├── repositories/
│       │   │   └── movie_repository.dart    # abstract contract
│       │   └── usecases/
│       │       ├── get_popular_movies.dart  # implements UseCase<List<MovieEntity>, NoParams>
│       │       └── get_movie_detail.dart    # implements UseCase<MovieDetailEntity, int>
│       └── presentation/
│           ├── bloc/
│           │   ├── movie_list/
│           │   │   ├── movie_list_bloc.dart
│           │   │   ├── movie_list_event.dart   # @freezed union events
│           │   │   └── movie_list_state.dart   # @freezed single state + status enum
│           │   └── movie_detail/
│           │       ├── movie_detail_bloc.dart
│           │       ├── movie_detail_event.dart # @freezed union events
│           │       └── movie_detail_state.dart # @freezed single state + status enum
│           ├── pages/
│           │   ├── movie_list_page.dart
│           │   └── movie_detail_page.dart
│           └── widgets/
│               ├── movie_card_widget.dart
│               ├── app_error_widget.dart    # shared error state UI
│               └── app_loading_widget.dart  # shared loading UI
└── utils/
    └── routes/
        ├── app_name_routes.dart  # const string route names + paths
        └── app_routes.dart       # GoRouter config

test/
├── helpers/
│   ├── mock_data.dart      # dummy JSON + entity fixtures
│   └── test_helper.dart    # shared Mock classes
└── features/
    └── movie/
        ├── data/
        │   ├── datasources/
        │   │   ├── movie_list_remote_datasource_test.dart
        │   │   ├── movie_detail_remote_datasource_test.dart
        │   │   └── movie_local_datasource_test.dart
        │   └── repositories/
        │       └── movie_repository_impl_test.dart
        ├── domain/
        │   └── usecases/
        │       ├── get_popular_movies_test.dart
        │       └── get_movie_detail_test.dart
        └── presentation/
            └── bloc/
                ├── movie_list_bloc_test.dart
                └── movie_detail_bloc_test.dart
```

---

## 5. Layer Contracts

### 5.1 Core — NetworkClient

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

- `HttpNetworkClient` implements via `http.Client` — maps status codes to `ServerException` / `ClientException`
- `DioNetworkClient` implements via `Dio` — maps `DioException` to same exceptions. Dio instance configured with `BaseOptions` (baseUrl, timeouts) and `AuthInterceptor` that reads token from `StorageService`

### 5.2 Core — UseCase Base

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
```

All use cases implement `UseCase<ReturnType, ParamsType>`. Bloc calls `useCase(params)`.

### 5.3 Core — Exceptions & Failure

```dart
// exception.dart
class ServerException implements Exception {}
class ClientException implements Exception {
  final String message;
  ClientException(this.message);
}
class CacheException implements Exception {}

// failure.dart
class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}
```

### 5.4 Domain — Entities (freezed, no JSON)

```dart
@freezed
class MovieEntity with _$MovieEntity {
  const factory MovieEntity({
    required int id,
    required String title,
    required String overview,
    required String posterPath,
    required double voteAverage,
  }) = _MovieEntity;
}
```

### 5.5 Data — Models (freezed + fromJson)

`@freezed` dan `@HiveType` tidak digabung — dua code-gen tersebut clash pada class yang sama. Hive box menyimpan JSON string, lalu `fromJson`/`toJson` (dari freezed) dipakai untuk serialize/deserialize. Tidak perlu `hive_generator`.

```dart
@freezed
class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') required String posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
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
  );
}
```

### 5.6 Datasource — Remote (zero exception handling)

```dart
class MovieListRemoteDatasourceImpl implements MovieListRemoteDatasource {
  final NetworkClient client;

  MovieListRemoteDatasourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final data = await client.get(ApiEndpoint.popularMovies);
    return (data['results'] as List)
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
```

### 5.7 Datasource — Local (Hive, JSON string)

Hive box typed as `Box<String>`. Serialize via `jsonEncode(model.toJson())`, deserialize via `MovieModel.fromJson(jsonDecode(raw))`. No TypeAdapter, no hive_generator needed.

```dart
class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  final Box<String> movieBox;

  MovieLocalDatasourceImpl({required this.movieBox});

  Future<void> cachePopularMovies(List<MovieModel> movies) async {
    await movieBox.clear();
    final map = {
      for (final m in movies) m.id.toString(): jsonEncode(m.toJson()),
    };
    await movieBox.putAll(map);
  }

  Future<List<MovieModel>> getCachedPopularMovies() async {
    final raws = movieBox.values.toList();
    if (raws.isEmpty) throw CacheException();
    return raws
        .map((r) => MovieModel.fromJson(jsonDecode(r) as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheMovieDetail(MovieModel movie) =>
      movieBox.put('detail_${movie.id}', jsonEncode(movie.toJson()));

  Future<MovieModel> getCachedMovieDetail(int movieId) async {
    final raw = movieBox.get('detail_$movieId');
    if (raw == null) throw CacheException();
    return MovieModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
```

### 5.8 Repository — Network-First Cache Strategy

```dart
@override
Future<Either<Failure, List<MovieEntity>>> getPopularMovies() async {
  try {
    final remote = await remoteList.getPopularMovies();
    await local.cachePopularMovies(remote);
    return Right(remote.map((e) => e.toEntity()).toList());
  } catch (_) {
    try {
      final cached = await local.getCachedPopularMovies();
      return Right(cached.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
```

### 5.9 Bloc — Single State with Status Enum

```dart
enum MovieListStatus { initial, loading, success, failure }

@freezed
class MovieListState with _$MovieListState {
  const factory MovieListState({
    @Default(MovieListStatus.initial) MovieListStatus status,
    @Default([]) List<MovieEntity> movies,
    String? errorMessage,
  }) = _MovieListState;
}

@freezed
class MovieListEvent with _$MovieListEvent {
  const factory MovieListEvent.started() = _Started;
  const factory MovieListEvent.refresh() = _Refresh;
}
```

Bloc calls `useCase(NoParams())`, emits `state.copyWith(status: ...)`.

### 5.10 Routing — GoRouter

```dart
// app_name_routes.dart
class AppNameRoutes {
  static const splash = '/';
  static const movieList = '/movies';
  static const movieDetail = 'detail'; // nested under movieList
}

// app_routes.dart
final router = GoRouter(
  initialLocation: AppNameRoutes.movieList,
  routes: [
    GoRoute(
      path: AppNameRoutes.movieList,
      builder: (_, __) => const MovieListPage(),
      routes: [
        GoRoute(
          path: '${AppNameRoutes.movieDetail}/:id',
          builder: (_, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MovieDetailPage(movieId: id);
          },
        ),
      ],
    ),
  ],
);
```

### 5.11 DI — Per-Feature GetIt Instance

```dart
// movie_injection.dart
final movieInjection = GetIt.asNewInstance();

// movie_datasource_injection.dart — inject different NetworkClient per datasource
movieInjection
  ..registerLazySingleton<NetworkClient>(
      () => HttpNetworkClient(client: http.Client()),
      instanceName: 'http',
    )
  ..registerLazySingleton<NetworkClient>(
      () => DioNetworkClient(dio: movieInjection()),
      instanceName: 'dio',
    )
  ..registerLazySingleton<MovieListRemoteDatasource>(
      () => MovieListRemoteDatasourceImpl(
            client: movieInjection(instanceName: 'http'),
          ),
    )
  ..registerLazySingleton<MovieDetailRemoteDatasource>(
      () => MovieDetailRemoteDatasourceImpl(
            client: movieInjection(instanceName: 'dio'),
          ),
    )
  ..registerLazySingleton<MovieLocalDatasource>(
      () => MovieLocalDatasourceImpl(movieBox: movieInjection()),
    );

// movie_feature_injection.dart — blocs as factory (new instance per page)
movieInjection
  ..registerFactory(() => MovieListBloc(getPopularMovies: movieInjection()))
  ..registerFactory(() => MovieDetailBloc(getMovieDetail: movieInjection()));
```

---

## 6. Storage

### Token — `flutter_secure_storage`

```dart
class StorageService {
  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) =>
      _storage.write(key: StorageKeys.token, value: token);

  Future<String?> getToken() =>
      _storage.read(key: StorageKeys.token);

  Future<void> deleteToken() =>
      _storage.delete(key: StorageKeys.token);
}
```

### Feature Cache — Hive

One `Box<ModelType>` per feature, opened during DI init:
```dart
final movieBox = await Hive.openBox<MovieModel>(StorageKeys.movieBox);
```

---

## 7. Unit Testing

### Coverage map

| Layer | Mock target | Tool |
|---|---|---|
| Datasource (http) | `NetworkClient` | mocktail |
| Datasource (dio) | `NetworkClient` | mocktail |
| Datasource (hive) | Hive in-memory (setUp/tearDown) | — |
| Repository | 3 datasources | mocktail |
| Use case | `MovieRepository` | mocktail |
| Bloc | Use cases | mocktail + bloc_test |

### Shared helpers

```
test/helpers/
  mock_data.dart     # static dummy JSON + entity instances
  test_helper.dart   # Mock classes: MockMovieRepository, MockNetworkClient, etc.
```

### Bloc test pattern

```dart
blocTest<MovieListBloc, MovieListState>(
  'emits loading then success when getPopularMovies succeeds',
  build: () {
    when(() => mockGetPopularMovies(NoParams()))
        .thenAnswer((_) async => Right(tMovieList));
    return MovieListBloc(getPopularMovies: mockGetPopularMovies);
  },
  act: (bloc) => bloc.add(const MovieListEvent.started()),
  expect: () => [
    const MovieListState(status: MovieListStatus.loading),
    MovieListState(status: MovieListStatus.success, movies: tMovieList),
  ],
);
```

---

## 8. Observer

```dart
// main.dart
void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
```

`AppBlocObserver` logs `onTransition` and `onError` via `debugPrint` in debug mode only.

---

## 9. TMDB Endpoints Used

| Use case | Endpoint |
|---|---|
| Get popular movies | `GET /movie/popular` |
| Get movie detail | `GET /movie/{movie_id}` |

Base URL: `https://api.themoviedb.org/3`  
Auth: Bearer token via `AuthInterceptor` (Dio) and header in `HttpNetworkClient`.

---

## 10. Out of Scope

- Authentication / login flow
- Pagination
- Offline-first sync
- Widget/integration tests
- CI/CD pipeline
