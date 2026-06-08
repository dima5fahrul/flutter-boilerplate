import '../../../../core/constant/api_endpoint.dart';
import '../../../../core/network/network_client.dart';
import '../models/movie_detail_model.dart';

abstract class MovieDetailRemoteDatasource {
  Future<MovieDetailModel> getMovieDetail(int movieId);
}

class MovieDetailRemoteDatasourceImpl implements MovieDetailRemoteDatasource {
  final NetworkClient client;

  const MovieDetailRemoteDatasourceImpl({required this.client});

  @override
  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final data = await client.get(ApiEndpoint.movieDetail(movieId));
    return MovieDetailModel.fromJson(data);
  }
}
