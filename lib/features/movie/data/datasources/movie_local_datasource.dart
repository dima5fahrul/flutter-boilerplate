import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/error/exception.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDatasource {
  Future<void> cachePopularMovies(List<MovieModel> movies);
  Future<List<MovieModel>> getCachedPopularMovies();
  Future<void> cacheMovieDetail(MovieModel movie);
  Future<MovieModel> getCachedMovieDetail(int movieId);
}

class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  final Box<String> movieBox;

  const MovieLocalDatasourceImpl({required this.movieBox});

  @override
  Future<void> cachePopularMovies(List<MovieModel> movies) async {
    await movieBox.clear();
    await movieBox.putAll({
      for (final m in movies) m.id.toString(): jsonEncode(m.toJson()),
    });
  }

  @override
  Future<List<MovieModel>> getCachedPopularMovies() async {
    final listRaws = movieBox.keys
        .where((k) => !k.toString().startsWith('detail_'))
        .map((k) => movieBox.get(k.toString())!)
        .toList();
    if (listRaws.isEmpty) throw CacheException();
    return listRaws
        .map((r) => MovieModel.fromJson(jsonDecode(r) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheMovieDetail(MovieModel movie) =>
      movieBox.put('detail_${movie.id}', jsonEncode(movie.toJson()));

  @override
  Future<MovieModel> getCachedMovieDetail(int movieId) async {
    final raw = movieBox.get('detail_$movieId');
    if (raw == null) throw CacheException();
    return MovieModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
