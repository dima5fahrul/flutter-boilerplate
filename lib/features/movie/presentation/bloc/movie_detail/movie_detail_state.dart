part of 'movie_detail_bloc.dart';

enum MovieDetailStatus { initial, loading, success, failure }

@freezed
abstract class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState({
    @Default(MovieDetailStatus.initial) MovieDetailStatus status,
    MovieDetailEntity? movie,
    String? errorMessage,
  }) = _MovieDetailState;
}
