import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_local_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_model.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  late Box<String> box;
  late MovieLocalDatasourceImpl datasource;

  setUp(() async {
    Hive.init('.');
    box = await Hive.openBox<String>('test_movie_box');
    datasource = MovieLocalDatasourceImpl(movieBox: box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('cachePopularMovies / getCachedPopularMovies', () {
    test('stores and retrieves popular movies', () async {
      await datasource.cachePopularMovies([tMovieModel]);

      final result = await datasource.getCachedPopularMovies();

      expect(result, isA<List<MovieModel>>());
      expect(result.first.title, 'Test Movie');
    });

    test('throws CacheException when box is empty', () async {
      expect(
        () => datasource.getCachedPopularMovies(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cacheMovieDetail / getCachedMovieDetail', () {
    test('stores and retrieves movie detail', () async {
      await datasource.cacheMovieDetail(tMovieModel);

      final result = await datasource.getCachedMovieDetail(1);

      expect(result.id, 1);
      expect(result.title, 'Test Movie');
    });

    test('throws CacheException when detail not cached', () async {
      expect(
        () => datasource.getCachedMovieDetail(999),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
