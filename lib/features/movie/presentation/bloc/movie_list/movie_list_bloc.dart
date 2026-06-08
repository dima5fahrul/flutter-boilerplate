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
