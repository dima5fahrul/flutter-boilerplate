# Flutter Boilerplate

Flutter boilerplate dengan **Clean Architecture**, TMDB API, dan full unit test coverage. Dirancang sebagai template project Flutter yang scalable dan maintainable.

---

## Tech Stack

| Kategori | Package |
|---|---|
| State Management | `flutter_bloc` + `bloc` |
| Dependency Injection | `get_it` |
| Routing | `go_router` |
| Network | `http` + `dio` |
| Local Cache | `hive` + `hive_flutter` |
| Secure Storage | `flutter_secure_storage` |
| Error Handling | `dartz` (Either) |
| Code Generation | `freezed` + `json_serializable` |
| Testing | `mocktail` + `bloc_test` |

---

## Arsitektur

Clean Architecture 3 layer per feature:

```
data       → network (http/dio) + local cache (hive), mapping JSON → model
domain     → entities, use cases, repository contracts (pure Dart)
presentation → BLoC, pages, widgets
```

Dependency hanya ke dalam: `presentation → domain ← data`

---

## Struktur Folder

```
lib/
├── core/
│   ├── constant/       # API endpoint constants
│   ├── di/             # Root dependency injection
│   ├── error/          # Exception + Failure classes
│   ├── network/        # NetworkClient abstraction (http + dio)
│   ├── observer/       # AppBlocObserver (debug logging)
│   ├── storage/        # StorageService (flutter_secure_storage)
│   └── usecase/        # UseCase<Output, Params> base class
├── features/
│   └── movie/          # Contoh feature (TMDB popular movies + detail)
│       ├── data/       # Models, datasources, repository impl
│       ├── di/         # Per-feature GetIt instance
│       ├── domain/     # Entities, repository contract, use cases
│       └── presentation/ # BLoC, pages, widgets
└── utils/
    └── routes/         # GoRouter config + route names
```

---

## Pattern Utama

### NetworkClient Abstraction
Exception handling terpusat — datasource bebas dari try/catch:
- `HttpNetworkClient` → pakai `http` package
- `DioNetworkClient` → pakai `dio` + `AuthInterceptor`

### BLoC — Single State + Status Enum
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
```

### Repository — Network-First Cache
```
1. Fetch remote → sukses: cache ke Hive, return Right(data)
2. Remote gagal → ambil dari Hive cache, return Right(cached)
3. Keduanya gagal → return Left(Failure)
```

### Dependency Injection — Per Feature
```dart
final movieInjection = GetIt.asNewInstance(); // isolated per feature
```

---

## Menambah Feature Baru

1. Buat folder `lib/features/<nama_feature>/` dengan subfolder `data/`, `domain/`, `presentation/`, `di/`
2. Domain: definisikan entity (`@freezed`), repository contract, use cases
3. Data: buat model (`@freezed` + `fromJson`), datasources (inject `NetworkClient`), repository impl
4. Presentation: BLoC (freezed single-state), pages, widgets
5. DI: buat `<feature>_injection.dart` + 4 injection files, daftarkan di `DependencyInjection`
6. Routing: tambahkan route di `AppRoutes`

---

## Setup

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### API Key

Boilerplate menggunakan TMDB API. Token ada di `lib/core/constant/api_endpoint.dart`.
Untuk production, gunakan `--dart-define`:

```bash
flutter run --dart-define=TMDB_TOKEN=your_token_here
```

---

## Testing

```bash
# Jalankan semua test
flutter test

# Dengan output detail
flutter test --reporter expanded
```

Coverage: datasources, repository, use cases, BLoC — semua layer di-test dengan `mocktail`.

---

## Hasil Test

```
20 tests — 0 failures
├── data/datasources   9 tests
├── data/repositories  5 tests  
├── domain/usecases    2 tests
└── presentation/bloc  4 tests
```

---

## Proses Pembuatan

Project ini dibuat sepenuhnya menggunakan **Claude Code** dengan orkestrasi [Superpowers](https://github.com/anthropics/claude-code) melalui alur berikut:

### 1. Brainstorming
Sesi tanya-jawab iteratif untuk mendefinisikan stack, pola arsitektur, dan keputusan desain (NetworkClient abstraction, single-state BLoC, Hive JSON-string cache, dll).

### 2. Design Spec
Spesifikasi desain lengkap ditulis ke `docs/superpowers/specs/` mencakup folder structure, layer contracts, package stack, DI strategy, dan testing coverage map.

### 3. Writing Plans
Implementation plan detail 20 task ditulis ke `docs/superpowers/plans/` — setiap task berisi exact file paths, complete code, dan expected test output. Zero placeholder.

### 4. Subagent-Driven Development (SDD)
Setiap task dieksekusi oleh **fresh subagent** yang terisolasi, diikuti dua tahap review:
- **Spec compliance review** — memastikan implementasi sesuai spec
- **Code quality review** — mendeteksi bug, race condition, dan anti-pattern

```
Orchestrator
├── Task 1  → Implementer subagent → Spec reviewer → Quality reviewer ✅
├── Task 2  → Implementer subagent → Spec reviewer → Quality reviewer ✅
├── ...
└── Task 20 → Final verification (20 tests passing, analyzer clean) ✅
```

Beberapa perbaikan nyata yang ditemukan oleh review loop:
- JSON decode sebelum status check di `HttpNetworkClient` → fixed
- `super.onError()` dipanggil setelah logging di `AppBlocObserver` → fixed
- `bloc_test: ^9.1.7` inkompatibel dengan `bloc: ^9.0.0` → upgrade ke `^10.0.0`
- `@freezed` class butuh `abstract class` di Freezed v3 → fixed di semua files
- `android:allowBackup` tidak di-set → added untuk proteksi `flutter_secure_storage`

> Docs lengkap ada di `docs/superpowers/` (spec + plan).
