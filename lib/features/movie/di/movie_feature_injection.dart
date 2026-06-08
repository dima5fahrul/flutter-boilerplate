import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/get_popular_movies.dart';
import '../presentation/bloc/movie_detail/movie_detail_bloc.dart';
import '../presentation/bloc/movie_list/movie_list_bloc.dart';
import 'movie_datasource_injection.dart';
import 'movie_injection.dart';
import 'movie_repository_injection.dart';
import 'movie_usecase_injection.dart';

class MovieFeatureInjection {
  static Future<void> init() async {
    await MovieDatasourceInjection.inject();
    MovieRepositoryInjection.inject();
    MovieUsecaseInjection.inject();

    movieInjection
      ..registerFactory(
        () => MovieListBloc(getPopularMovies: movieInjection<GetPopularMovies>()),
      )
      ..registerFactory(
        () => MovieDetailBloc(getMovieDetail: movieInjection<GetMovieDetail>()),
      );
  }
}
