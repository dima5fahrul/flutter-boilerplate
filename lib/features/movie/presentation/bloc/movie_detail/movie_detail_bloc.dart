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
