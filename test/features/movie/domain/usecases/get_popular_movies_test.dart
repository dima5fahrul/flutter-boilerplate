import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/core/usecase/usecase.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_popular_movies.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late GetPopularMovies useCase;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    useCase = GetPopularMovies(repository: mockRepository);
  });

  test('returns list of MovieEntity from repository', () async {
    when(() => mockRepository.getPopularMovies())
        .thenAnswer((_) async => Right(tMovieList));

    final result = await useCase(NoParams());

    expect(result, Right(tMovieList));
    verify(() => mockRepository.getPopularMovies()).called(1);
  });
}
