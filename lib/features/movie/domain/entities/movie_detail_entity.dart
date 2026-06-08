import 'package:freezed_annotation/freezed_annotation.dart';
import 'genre_entity.dart';

part 'movie_detail_entity.freezed.dart';

@freezed
abstract class MovieDetailEntity with _$MovieDetailEntity {
  const factory MovieDetailEntity({
    required int id,
    required String title,
    required String overview,
    required String posterPath,
    required double voteAverage,
    required String releaseDate,
    required int runtime,
    required List<GenreEntity> genres,
    required String tagline,
    required String status,
  }) = _MovieDetailEntity;
}
