import '../../../../core/constant/api_endpoint.dart';
import '../../../../core/network/network_client.dart';
import '../models/movie_model.dart';

abstract class MovieListRemoteDatasource {
  Future<List<MovieModel>> getPopularMovies();
}

class MovieListRemoteDatasourceImpl implements MovieListRemoteDatasource {
  final NetworkClient client;

  const MovieListRemoteDatasourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final data = await client.get(ApiEndpoint.popularMovies);
    return (data['results'] as List)
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
