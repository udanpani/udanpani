// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Job _$JobFromJson(Map<String, dynamic> json) {
  return _Job.fromJson(json);
}

/// @nodoc
mixin _$Job {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get posterUid => throw _privateConstructorUsedError;
  String get locX => throw _privateConstructorUsedError;
  String get locY => throw _privateConstructorUsedError;
  List<String>? get applicants => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JobCopyWith<Job> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobCopyWith<$Res> {
  factory $JobCopyWith(Job value, $Res Function(Job) then) =
      _$JobCopyWithImpl<$Res>;
  $Res call(
      {String title,
      String description,
      String posterUid,
      String locX,
      String locY,
      List<String>? applicants});
}

/// @nodoc
class _$JobCopyWithImpl<$Res> implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._value, this._then);

  final Job _value;
  // ignore: unused_field
  final $Res Function(Job) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? posterUid = freezed,
    Object? locX = freezed,
    Object? locY = freezed,
    Object? applicants = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      posterUid: posterUid == freezed
          ? _value.posterUid
          : posterUid // ignore: cast_nullable_to_non_nullable
              as String,
      locX: locX == freezed
          ? _value.locX
          : locX // ignore: cast_nullable_to_non_nullable
              as String,
      locY: locY == freezed
          ? _value.locY
          : locY // ignore: cast_nullable_to_non_nullable
              as String,
      applicants: applicants == freezed
          ? _value.applicants
          : applicants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
abstract class _$$_JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$$_JobCopyWith(_$_Job value, $Res Function(_$_Job) then) =
      __$$_JobCopyWithImpl<$Res>;
  @override
  $Res call(
      {String title,
      String description,
      String posterUid,
      String locX,
      String locY,
      List<String>? applicants});
}

/// @nodoc
class __$$_JobCopyWithImpl<$Res> extends _$JobCopyWithImpl<$Res>
    implements _$$_JobCopyWith<$Res> {
  __$$_JobCopyWithImpl(_$_Job _value, $Res Function(_$_Job) _then)
      : super(_value, (v) => _then(v as _$_Job));

  @override
  _$_Job get _value => super._value as _$_Job;

  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? posterUid = freezed,
    Object? locX = freezed,
    Object? locY = freezed,
    Object? applicants = freezed,
  }) {
    return _then(_$_Job(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      posterUid: posterUid == freezed
          ? _value.posterUid
          : posterUid // ignore: cast_nullable_to_non_nullable
              as String,
      locX: locX == freezed
          ? _value.locX
          : locX // ignore: cast_nullable_to_non_nullable
              as String,
      locY: locY == freezed
          ? _value.locY
          : locY // ignore: cast_nullable_to_non_nullable
              as String,
      applicants: applicants == freezed
          ? _value._applicants
          : applicants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Job implements _Job {
  _$_Job(
      {required this.title,
      required this.description,
      required this.posterUid,
      required this.locX,
      required this.locY,
      final List<String>? applicants})
      : _applicants = applicants;

  factory _$_Job.fromJson(Map<String, dynamic> json) => _$$_JobFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final String posterUid;
  @override
  final String locX;
  @override
  final String locY;
  final List<String>? _applicants;
  @override
  List<String>? get applicants {
    final value = _applicants;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Job(title: $title, description: $description, posterUid: $posterUid, locX: $locX, locY: $locY, applicants: $applicants)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Job &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.posterUid, posterUid) &&
            const DeepCollectionEquality().equals(other.locX, locX) &&
            const DeepCollectionEquality().equals(other.locY, locY) &&
            const DeepCollectionEquality()
                .equals(other._applicants, _applicants));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(posterUid),
      const DeepCollectionEquality().hash(locX),
      const DeepCollectionEquality().hash(locY),
      const DeepCollectionEquality().hash(_applicants));

  @JsonKey(ignore: true)
  @override
  _$$_JobCopyWith<_$_Job> get copyWith =>
      __$$_JobCopyWithImpl<_$_Job>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_JobToJson(this);
  }
}

abstract class _Job implements Job {
  factory _Job(
      {required final String title,
      required final String description,
      required final String posterUid,
      required final String locX,
      required final String locY,
      final List<String>? applicants}) = _$_Job;

  factory _Job.fromJson(Map<String, dynamic> json) = _$_Job.fromJson;

  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  String get posterUid => throw _privateConstructorUsedError;
  @override
  String get locX => throw _privateConstructorUsedError;
  @override
  String get locY => throw _privateConstructorUsedError;
  @override
  List<String>? get applicants => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_JobCopyWith<_$_Job> get copyWith => throw _privateConstructorUsedError;
}
