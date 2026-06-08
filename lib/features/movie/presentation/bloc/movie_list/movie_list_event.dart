part of 'movie_list_bloc.dart';

@freezed
abstract class MovieListEvent with _$MovieListEvent {
  const factory MovieListEvent.started() = _Started;
  const factory MovieListEvent.refresh() = _Refresh;
}
