import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_movie_detail.dart';
import '../../../../helpers/mock_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late GetMovieDetail useCase;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    useCase = GetMovieDetail(repository: mockRepository);
  });

  test('returns MovieDetailEntity from repository', () async {
    when(() => mockRepository.getMovieDetail(1))
        .thenAnswer((_) async => const Right(tMovieDetailEntity));

    final result = await useCase(1);

    expect(result, const Right(tMovieDetailEntity));
    verify(() => mockRepository.getMovieDetail(1)).called(1);
  });
}
