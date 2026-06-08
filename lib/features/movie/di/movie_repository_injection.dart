import '../data/datasources/movie_detail_remote_datasource.dart';
import '../data/datasources/movie_list_remote_datasource.dart';
import '../data/datasources/movie_local_datasource.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import 'movie_injection.dart';

class MovieRepositoryInjection {
  static void inject() {
    movieInjection.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(
        remoteList: movieInjection<MovieListRemoteDatasource>(),
        remoteDetail: movieInjection<MovieDetailRemoteDatasource>(),
        local: movieInjection<MovieLocalDatasource>(),
      ),
    );
  }
}
