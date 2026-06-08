import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_detail_remote_datasource.dart';
import '../datasources/movie_list_remote_datasource.dart';
import '../datasources/movie_local_datasource.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieListRemoteDatasource remoteList;
  final MovieDetailRemoteDatasource remoteDetail;
  final MovieLocalDatasource local;

  const MovieRepositoryImpl({
    required this.remoteList,
    required this.remoteDetail,
    required this.local,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies() async {
    try {
      final remote = await remoteList.getPopularMovies();
      await local.cachePopularMovies(remote);
      return Right(remote.map((m) => m.toEntity()).toList());
    } catch (_) {
      try {
        final cached = await local.getCachedPopularMovies();
        return Right(cached.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int movieId) async {
    try {
      final remote = await remoteDetail.getMovieDetail(movieId);
      return Right(remote.toEntity());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
