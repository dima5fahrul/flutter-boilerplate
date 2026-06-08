// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieDetailModel _$MovieDetailModelFromJson(Map<String, dynamic> json) =>
    _MovieDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] as String,
      runtime: (json['runtime'] as num).toInt(),
      genres:
          (json['genres'] as List<dynamic>)
              .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      tagline: json['tagline'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$MovieDetailModelToJson(_MovieDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'vote_average': instance.voteAverage,
      'release_date': instance.releaseDate,
      'runtime': instance.runtime,
      'genres': instance.genres,
      'tagline': instance.tagline,
      'status': instance.status,
    };
