import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie_detail_entity.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetail implements UseCase<MovieDetailEntity, int> {
  final MovieRepository repository;

  const GetMovieDetail({required this.repository});

  @override
  Future<Either<Failure, MovieDetailEntity>> call(int params) =>
      repository.getMovieDetail(params);
}
