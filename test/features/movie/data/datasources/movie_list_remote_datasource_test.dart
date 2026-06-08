import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_list_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_model.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MovieListRemoteDatasourceImpl datasource;
  late MockNetworkClient mockClient;

  setUp(() {
    mockClient = MockNetworkClient();
    datasource = MovieListRemoteDatasourceImpl(client: mockClient);
  });

  group('getPopularMovies', () {
    test('returns list of MovieModel on success', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => tPopularMoviesJson);

      final result = await datasource.getPopularMovies();

      expect(result, isA<List<MovieModel>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Movie');
    });

    test('propagates ServerException from NetworkClient', () async {
      when(() => mockClient.get(any())).thenThrow(ServerException());

      expect(() => datasource.getPopularMovies(), throwsA(isA<ServerException>()));
    });

    test('propagates ClientException from NetworkClient', () async {
      when(() => mockClient.get(any())).thenThrow(const ClientException('Not found'));

      expect(() => datasource.getPopularMovies(), throwsA(isA<ClientException>()));
    });
  });
}
