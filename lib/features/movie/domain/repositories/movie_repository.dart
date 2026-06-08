import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/movie_detail_entity.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies();
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int movieId);
}
