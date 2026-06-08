# Flutter Boilerplate

Flutter boilerplate with **Clean Architecture**, TMDB API integration, and full unit test coverage. Designed as a scalable and maintainable Flutter project template.

---

## Tech Stack

| Category | Package |
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

## Architecture

Clean Architecture with 3 layers per feature:

```
data         → network (http/dio) + local cache (hive), maps JSON → model
domain       → entities, use cases, repository contracts (pure Dart)
presentation → BLoC, pages, widgets
```

Dependencies only point inward: `presentation → domain ← data`

---

## Folder Structure

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
│   └── movie/          # Example feature (TMDB popular movies + detail)
│       ├── data/       # Models, datasources, repository impl
│       ├── di/         # Per-feature GetIt instance
│       ├── domain/     # Entities, repository contract, use cases
│       └── presentation/ # BLoC, pages, widgets
└── utils/
    └── routes/         # GoRouter config + route names
```

---

## Key Patterns

### NetworkClient Abstraction
Exception handling is centralized — datasources stay clean:
- `HttpNetworkClient` → uses `http` package
- `DioNetworkClient` → uses `dio` + `AuthInterceptor`

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

### Repository — Network-First Cache Strategy
```
1. Fetch remote → success: cache to Hive, return Right(data)
2. Remote fails → load from Hive cache, return Right(cached)
3. Both fail    → return Left(Failure)
```

### Dependency Injection — Per Feature
```dart
final movieInjection = GetIt.asNewInstance(); // isolated per feature
```

---

## Adding a New Feature

1. Create `lib/features/<feature_name>/` with subfolders `data/`, `domain/`, `presentation/`, `di/`
2. Domain: define entity (`@freezed`), repository contract, use cases
3. Data: create model (`@freezed` + `fromJson`), datasources (inject `NetworkClient`), repository impl
4. Presentation: BLoC (freezed single-state), pages, widgets
5. DI: create `<feature>_injection.dart` + 4 injection files, register in `DependencyInjection`
6. Routing: add route in `AppRoutes`

---

## Setup

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### API Key

This boilerplate uses the TMDB API. The token is in `lib/core/constant/api_endpoint.dart`.
For production, use `--dart-define`:

```bash
flutter run --dart-define=TMDB_TOKEN=your_token_here
```

---

## Testing

```bash
# Run all tests
flutter test

# With detailed output
flutter test --reporter expanded
```

Coverage: datasources, repository, use cases, BLoC — all layers tested with `mocktail`.

---

## Test Results

```
20 tests — 0 failures
├── data/datasources   9 tests
├── data/repositories  5 tests
├── domain/usecases    2 tests
└── presentation/bloc  4 tests
```

---

## How This Was Built

This project was built entirely using **Claude Code** with [Superpowers](https://github.com/anthropics/claude-code) orchestration through the following workflow:

### 1. Brainstorming
Iterative Q&A sessions to define the stack, architecture patterns, and design decisions (NetworkClient abstraction, single-state BLoC, Hive JSON-string cache, etc.).

### 2. Design Spec
Full design specification written to `docs/superpowers/specs/` covering folder structure, layer contracts, package stack, DI strategy, and testing coverage map.

### 3. Writing Plans
Detailed 20-task implementation plan written to `docs/superpowers/plans/` — each task contains exact file paths, complete code, and expected test output. Zero placeholders.

### 4. Subagent-Driven Development (SDD)
Each task was executed by a **fresh isolated subagent**, followed by a two-stage review loop:
- **Spec compliance review** — verifies implementation matches the spec
- **Code quality review** — detects bugs, race conditions, and anti-patterns

```
Orchestrator
├── Task 1  → Implementer subagent → Spec reviewer → Quality reviewer ✅
├── Task 2  → Implementer subagent → Spec reviewer → Quality reviewer ✅
├── ...
└── Task 20 → Final verification (20 tests passing, analyzer clean) ✅
```

Real issues caught by the review loop:
- JSON decode before status check in `HttpNetworkClient` → fixed
- `super.onError()` called after logging in `AppBlocObserver` → fixed
- `bloc_test: ^9.1.7` incompatible with `bloc: ^9.0.0` → upgraded to `^10.0.0`
- `@freezed` classes require `abstract class` in Freezed v3 → fixed across all files
- `android:allowBackup` not set → added to protect `flutter_secure_storage` keys

> Full docs available in `docs/superpowers/` (spec + plan).
