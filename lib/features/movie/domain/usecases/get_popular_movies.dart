import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  const GetPopularMovies({required this.repository});

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) =>
      repository.getPopularMovies();
}
