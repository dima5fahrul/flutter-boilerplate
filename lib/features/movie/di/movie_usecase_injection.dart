import '../domain/repositories/movie_repository.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/get_popular_movies.dart';
import 'movie_injection.dart';

class MovieUsecaseInjection {
  static void inject() {
    movieInjection
      ..registerLazySingleton(
        () => GetPopularMovies(repository: movieInjection<MovieRepository>()),
      )
      ..registerLazySingleton(
        () => GetMovieDetail(repository: movieInjection<MovieRepository>()),
      );
  }
}
