import 'package:flutter_boilerplate/core/network/network_client.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_detail_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_list_remote_datasource.dart';
import 'package:flutter_boilerplate/features/movie/data/datasources/movie_local_datasource.dart';
import 'package:flutter_boilerplate/features/movie/domain/repositories/movie_repository.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:flutter_boilerplate/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkClient extends Mock implements NetworkClient {}
class MockMovieListRemoteDatasource extends Mock implements MovieListRemoteDatasource {}
class MockMovieDetailRemoteDatasource extends Mock implements MovieDetailRemoteDatasource {}
class MockMovieLocalDatasource extends Mock implements MovieLocalDatasource {}
class MockMovieRepository extends Mock implements MovieRepository {}
class MockGetPopularMovies extends Mock implements GetPopularMovies {}
class MockGetMovieDetail extends Mock implements GetMovieDetail {}
