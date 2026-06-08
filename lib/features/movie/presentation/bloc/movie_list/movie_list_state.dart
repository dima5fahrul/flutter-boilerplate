part of 'movie_list_bloc.dart';

enum MovieListStatus { initial, loading, success, failure }

@freezed
abstract class MovieListState with _$MovieListState {
  const factory MovieListState({
    @Default(MovieListStatus.initial) MovieListStatus status,
    @Default([]) List<MovieEntity> movies,
    String? errorMessage,
  }) = _MovieListState;
}
