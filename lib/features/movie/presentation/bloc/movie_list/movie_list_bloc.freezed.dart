// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieListEvent()';
}


}

/// @nodoc
class $MovieListEventCopyWith<$Res>  {
$MovieListEventCopyWith(MovieListEvent _, $Res Function(MovieListEvent) __);
}


/// Adds pattern-matching-related methods to [MovieListEvent].
extension MovieListEventPatterns on MovieListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Refresh value)?  refresh,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Refresh value)  refresh,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Refresh():
return refresh(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Refresh value)?  refresh,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Refresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refresh,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refresh() when refresh != null:
return refresh();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refresh,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Refresh():
return refresh();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refresh,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Refresh() when refresh != null:
return refresh();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements MovieListEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieListEvent.started()';
}


}




/// @nodoc


class _Refresh implements MovieListEvent {
  const _Refresh();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieListEvent.refresh()';
}


}




/// @nodoc
mixin _$MovieListState {

 MovieListStatus get status; List<MovieEntity> get movies; String? get errorMessage;
/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListStateCopyWith<MovieListState> get copyWith => _$MovieListStateCopyWithImpl<MovieListState>(this as MovieListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.movies, movies)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(movies),errorMessage);

@override
String toString() {
  return 'MovieListState(status: $status, movies: $movies, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $MovieListStateCopyWith<$Res>  {
  factory $MovieListStateCopyWith(MovieListState value, $Res Function(MovieListState) _then) = _$MovieListStateCopyWithImpl;
@useResult
$Res call({
 MovieListStatus status, List<MovieEntity> movies, String? errorMessage
});




}
/// @nodoc
class _$MovieListStateCopyWithImpl<$Res>
    implements $MovieListStateCopyWith<$Res> {
  _$MovieListStateCopyWithImpl(this._self, this._then);

  final MovieListState _self;
  final $Res Function(MovieListState) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? movies = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MovieListStatus,movies: null == movies ? _self.movies : movies // ignore: cast_nullable_to_non_nullable
as List<MovieEntity>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieListState].
extension MovieListStatePatterns on MovieListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieListState value)  $default,){
final _that = this;
switch (_that) {
case _MovieListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieListState value)?  $default,){
final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MovieListStatus status,  List<MovieEntity> movies,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
return $default(_that.status,_that.movies,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MovieListStatus status,  List<MovieEntity> movies,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _MovieListState():
return $default(_that.status,_that.movies,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MovieListStatus status,  List<MovieEntity> movies,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
return $default(_that.status,_that.movies,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _MovieListState implements MovieListState {
  const _MovieListState({this.status = MovieListStatus.initial, final  List<MovieEntity> movies = const [], this.errorMessage}): _movies = movies;
  

@override@JsonKey() final  MovieListStatus status;
 final  List<MovieEntity> _movies;
@override@JsonKey() List<MovieEntity> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

@override final  String? errorMessage;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieListStateCopyWith<_MovieListState> get copyWith => __$MovieListStateCopyWithImpl<_MovieListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._movies, _movies)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_movies),errorMessage);

@override
String toString() {
  return 'MovieListState(status: $status, movies: $movies, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$MovieListStateCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory _$MovieListStateCopyWith(_MovieListState value, $Res Function(_MovieListState) _then) = __$MovieListStateCopyWithImpl;
@override @useResult
$Res call({
 MovieListStatus status, List<MovieEntity> movies, String? errorMessage
});




}
/// @nodoc
class __$MovieListStateCopyWithImpl<$Res>
    implements _$MovieListStateCopyWith<$Res> {
  __$MovieListStateCopyWithImpl(this._self, this._then);

  final _MovieListState _self;
  final $Res Function(_MovieListState) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? movies = null,Object? errorMessage = freezed,}) {
  return _then(_MovieListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MovieListStatus,movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<MovieEntity>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
