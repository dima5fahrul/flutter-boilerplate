import 'package:flutter_boilerplate/features/movie/data/models/genre_model.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_detail_model.dart';
import 'package:flutter_boilerplate/features/movie/data/models/movie_model.dart';
import 'package:flutter_boilerplate/features/movie/domain/entities/genre_entity.dart';
import 'package:flutter_boilerplate/features/movie/domain/entities/movie_detail_entity.dart';
import 'package:flutter_boilerplate/features/movie/domain/entities/movie_entity.dart';

const tMovieModel = MovieModel(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
);

const tMovieDetailModel = MovieDetailModel(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
  runtime: 120,
  genres: [GenreModel(id: 28, name: 'Action')],
  tagline: 'Test tagline',
  status: 'Released',
);

const tMovieEntity = MovieEntity(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
);

const tMovieDetailEntity = MovieDetailEntity(
  id: 1,
  title: 'Test Movie',
  overview: 'Test overview',
  posterPath: '/test.jpg',
  voteAverage: 7.5,
  releaseDate: '2024-01-01',
  runtime: 120,
  genres: [GenreEntity(id: 28, name: 'Action')],
  tagline: 'Test tagline',
  status: 'Released',
);

final tMovieList = [tMovieEntity];

final tPopularMoviesJson = {
  'results': [
    {
      'id': 1,
      'title': 'Test Movie',
      'overview': 'Test overview',
      'poster_path': '/test.jpg',
      'vote_average': 7.5,
      'release_date': '2024-01-01',
    }
  ],
};

final tMovieDetailJson = {
  'id': 1,
  'title': 'Test Movie',
  'overview': 'Test overview',
  'poster_path': '/test.jpg',
  'vote_average': 7.5,
  'release_date': '2024-01-01',
  'runtime': 120,
  'genres': [
    {'id': 28, 'name': 'Action'}
  ],
  'tagline': 'Test tagline',
  'status': 'Released',
};
