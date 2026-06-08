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
