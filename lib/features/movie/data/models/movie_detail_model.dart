import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/movie_detail_entity.dart';
import 'genre_model.dart';

part 'movie_detail_model.freezed.dart';
part 'movie_detail_model.g.dart';

@freezed
abstract class MovieDetailModel with _$MovieDetailModel {
  const factory MovieDetailModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') required String posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String releaseDate,
    required int runtime,
    required List<GenreModel> genres,
    required String tagline,
    required String status,
  }) = _MovieDetailModel;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);
}

extension MovieDetailModelX on MovieDetailModel {
  MovieDetailEntity toEntity() => MovieDetailEntity(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        releaseDate: releaseDate,
        runtime: runtime,
        genres: genres.map((g) => g.toEntity()).toList(),
        tagline: tagline,
        status: status,
      );
}
