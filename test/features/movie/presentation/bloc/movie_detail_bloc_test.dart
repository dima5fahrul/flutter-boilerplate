import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    registerFallbackValue(1);
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits loading then success when getMovieDetail succeeds',
    build: () {
      when(() => mockGetMovieDetail(any()))
          .thenAnswer((_) async => const Right(tMovieDetailEntity));
      return MovieDetailBloc(getMovieDetail: mockGetMovieDetail);
    },
    act: (bloc) => bloc.add(const MovieDetailEvent.started(1)),
    expect: () => [
      const MovieDetailState(status: MovieDetailStatus.loading),
      const MovieDetailState(
        status: MovieDetailStatus.success,
        movie: tMovieDetailEntity,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits loading then failure when getMovieDetail fails',
    build: () {
      when(() => mockGetMovieDetail(any()))
          .thenAnswer((_) async => const Left(Failure('error')));
      return MovieDetailBloc(getMovieDetail: mockGetMovieDetail);
    },
    act: (bloc) => bloc.add(const MovieDetailEvent.started(1)),
    expect: () => [
      const MovieDetailState(status: MovieDetailStatus.loading),
      const MovieDetailState(
        status: MovieDetailStatus.failure,
        errorMessage: 'error',
      ),
    ],
  );
}
