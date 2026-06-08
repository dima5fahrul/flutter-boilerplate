import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/movie_entity.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
abstract class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') required String posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String releaseDate,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}

extension MovieModelX on MovieModel {
  MovieEntity toEntity() => MovieEntity(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        releaseDate: releaseDate,
      );
}
