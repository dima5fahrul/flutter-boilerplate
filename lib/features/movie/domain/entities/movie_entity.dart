import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_entity.freezed.dart';

@freezed
abstract class MovieEntity with _$MovieEntity {
  const factory MovieEntity({
    required int id,
    required String title,
    required String overview,
    required String posterPath,
    required double voteAverage,
    required String releaseDate,
  }) = _MovieEntity;
}
