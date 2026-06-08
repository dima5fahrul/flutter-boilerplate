import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/core/error/failure.dart';
import 'package:flutter_boilerplate/features/movie/data/repositories/movie_repository_impl.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieListRemoteDatasource mockRemoteList;
  late MockMovieDetailRemoteDatasource mockRemoteDetail;
  late MockMovieLocalDatasource mockLocal;

  setUp(() {
    mockRemoteList = MockMovieListRemoteDatasource();
    mockRemoteDetail = MockMovieDetailRemoteDatasource();
    mockLocal = MockMovieLocalDatasource();
    repository = MovieRepositoryImpl(
      remoteList: mockRemoteList,
      remoteDetail: mockRemoteDetail,
      local: mockLocal,
    );
  });

  group('getPopularMovies', () {
    test('returns Right(movies) and caches when remote succeeds', () async {
      when(() => mockRemoteList.getPopularMovies())
          .thenAnswer((_) async => [tMovieModel]);
      when(() => mockLocal.cachePopularMovies(any())).thenAnswer((_) async {});

      final result = await repository.getPopularMovies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (movies) => expect(movies, tMovieList),
      );
      verify(() => mockLocal.cachePopularMovies([tMovieModel])).called(1);
    });

    test('returns Right(cached) when remote fails but cache exists', () async {
      when(() => mockRemoteList.getPopularMovies()).thenThrow(ServerException());
      when(() => mockLocal.getCachedPopularMovies())
          .thenAnswer((_) async => [tMovieModel]);

      final result = await repository.getPopularMovies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (movies) => expect(movies, tMovieList),
      );
    });

    test('returns Left(Failure) when remote and cache both fail', () async {
      when(() => mockRemoteList.getPopularMovies()).thenThrow(ServerException());
      when(() => mockLocal.getCachedPopularMovies()).thenThrow(CacheException());

      final result = await repository.getPopularMovies();

      expect(result, isA<Left<Failure, dynamic>>());
    });
  });

  group('getMovieDetail', () {
    test('returns Right(detail) when remote succeeds', () async {
      when(() => mockRemoteDetail.getMovieDetail(1))
          .thenAnswer((_) async => tMovieDetailModel);

      final result = await repository.getMovieDetail(1);

      expect(result.isRight(), true);
    });

    test('returns Left(Failure) when remote fails', () async {
      when(() => mockRemoteDetail.getMovieDetail(1)).thenThrow(ServerException());

      final result = await repository.getMovieDetail(1);

      expect(result.isLeft(), true);
    });
  });
}
