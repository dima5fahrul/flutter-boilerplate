part of 'movie_detail_bloc.dart';

@freezed
abstract class MovieDetailEvent with _$MovieDetailEvent {
  const factory MovieDetailEvent.started(int movieId) = _Started;
}
