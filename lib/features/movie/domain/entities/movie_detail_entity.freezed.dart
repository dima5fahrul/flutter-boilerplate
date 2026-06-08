// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieDetailEntity {

 int get id; String get title; String get overview; String get posterPath; double get voteAverage; String get releaseDate; int get runtime; List<GenreEntity> get genres; String get tagline; String get status;
/// Create a copy of MovieDetailEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailEntityCopyWith<MovieDetailEntity> get copyWith => _$MovieDetailEntityCopyWithImpl<MovieDetailEntity>(this as MovieDetailEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,overview,posterPath,voteAverage,releaseDate,runtime,const DeepCollectionEquality().hash(genres),tagline,status);

@override
String toString() {
  return 'MovieDetailEntity(id: $id, title: $title, overview: $overview, posterPath: $posterPath, voteAverage: $voteAverage, releaseDate: $releaseDate, runtime: $runtime, genres: $genres, tagline: $tagline, status: $status)';
}


}

/// @nodoc
abstract mixin class $MovieDetailEntityCopyWith<$Res>  {
  factory $MovieDetailEntityCopyWith(MovieDetailEntity value, $Res Function(MovieDetailEntity) _then) = _$MovieDetailEntityCopyWithImpl;
@useResult
$Res call({
 int id, String title, String overview, String posterPath, double voteAverage, String releaseDate, int runtime, List<GenreEntity> genres, String tagline, String status
});




}
/// @nodoc
class _$MovieDetailEntityCopyWithImpl<$Res>
    implements $MovieDetailEntityCopyWith<$Res> {
  _$MovieDetailEntityCopyWithImpl(this._self, this._then);

  final MovieDetailEntity _self;
  final $Res Function(MovieDetailEntity) _then;

/// Create a copy of MovieDetailEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? overview = null,Object? posterPath = null,Object? voteAverage = null,Object? releaseDate = null,Object? runtime = null,Object? genres = null,Object? tagline = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: null == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String,runtime: null == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreEntity>,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieDetailEntity].
extension MovieDetailEntityPatterns on MovieDetailEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieDetailEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieDetailEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieDetailEntity value)  $default,){
final _that = this;
switch (_that) {
case _MovieDetailEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieDetailEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MovieDetailEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String overview,  String posterPath,  double voteAverage,  String releaseDate,  int runtime,  List<GenreEntity> genres,  String tagline,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieDetailEntity() when $default != null:
return $default(_that.id,_that.title,_that.overview,_that.posterPath,_that.voteAverage,_that.releaseDate,_that.runtime,_that.genres,_that.tagline,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String overview,  String posterPath,  double voteAverage,  String releaseDate,  int runtime,  List<GenreEntity> genres,  String tagline,  String status)  $default,) {final _that = this;
switch (_that) {
case _MovieDetailEntity():
return $default(_that.id,_that.title,_that.overview,_that.posterPath,_that.voteAverage,_that.releaseDate,_that.runtime,_that.genres,_that.tagline,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String overview,  String posterPath,  double voteAverage,  String releaseDate,  int runtime,  List<GenreEntity> genres,  String tagline,  String status)?  $default,) {final _that = this;
switch (_that) {
case _MovieDetailEntity() when $default != null:
return $default(_that.id,_that.title,_that.overview,_that.posterPath,_that.voteAverage,_that.releaseDate,_that.runtime,_that.genres,_that.tagline,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _MovieDetailEntity implements MovieDetailEntity {
  const _MovieDetailEntity({required this.id, required this.title, required this.overview, required this.posterPath, required this.voteAverage, required this.releaseDate, required this.runtime, required final  List<GenreEntity> genres, required this.tagline, required this.status}): _genres = genres;
  

@override final  int id;
@override final  String title;
@override final  String overview;
@override final  String posterPath;
@override final  double voteAverage;
@override final  String releaseDate;
@override final  int runtime;
 final  List<GenreEntity> _genres;
@override List<GenreEntity> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override final  String tagline;
@override final  String status;

/// Create a copy of MovieDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieDetailEntityCopyWith<_MovieDetailEntity> get copyWith => __$MovieDetailEntityCopyWithImpl<_MovieDetailEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieDetailEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,overview,posterPath,voteAverage,releaseDate,runtime,const DeepCollectionEquality().hash(_genres),tagline,status);

@override
String toString() {
  return 'MovieDetailEntity(id: $id, title: $title, overview: $overview, posterPath: $posterPath, voteAverage: $voteAverage, releaseDate: $releaseDate, runtime: $runtime, genres: $genres, tagline: $tagline, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MovieDetailEntityCopyWith<$Res> implements $MovieDetailEntityCopyWith<$Res> {
  factory _$MovieDetailEntityCopyWith(_MovieDetailEntity value, $Res Function(_MovieDetailEntity) _then) = __$MovieDetailEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String overview, String posterPath, double voteAverage, String releaseDate, int runtime, List<GenreEntity> genres, String tagline, String status
});




}
/// @nodoc
class __$MovieDetailEntityCopyWithImpl<$Res>
    implements _$MovieDetailEntityCopyWith<$Res> {
  __$MovieDetailEntityCopyWithImpl(this._self, this._then);

  final _MovieDetailEntity _self;
  final $Res Function(_MovieDetailEntity) _then;

/// Create a copy of MovieDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? overview = null,Object? posterPath = null,Object? voteAverage = null,Object? releaseDate = null,Object? runtime = null,Object? genres = null,Object? tagline = null,Object? status = null,}) {
  return _then(_MovieDetailEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: null == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String,runtime: null == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreEntity>,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
