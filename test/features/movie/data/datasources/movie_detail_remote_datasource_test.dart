import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/error/exception.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_detail_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_detail_model.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late MovieDetailRemoteDatasourceImpl datasource;
  late MockNetworkClient mockClient;

  setUp(() {
    mockClient = MockNetworkClient();
    datasource = MovieDetailRemoteDatasourceImpl(client: mockClient);
  });

  group('getMovieDetail', () {
    test('returns MovieDetailModel on success', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => tMovieDetailJson);

      final result = await datasource.getMovieDetail(1);

      expect(result, isA<MovieDetailModel>());
      expect(result.title, 'Test Movie');
      expect(result.runtime, 120);
    });

    test('propagates ServerException from NetworkClient', () async {
      when(() => mockClient.get(any())).thenThrow(ServerException());

      expect(() => datasource.getMovieDetail(1), throwsA(isA<ServerException>()));
    });
  });
}
