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
  String? get jobId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get posterUid => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  dynamic get geoHash => throw _privateConstructorUsedError;
  String get locationAsName => throw _privateConstructorUsedError;
  List<String>? get applicants => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending for inviting application
// pending -> accepted ->  in progress -> paid -> completed
  String? get acceptedApplicant => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  bool get workerReviewed => throw _privateConstructorUsedError;
  bool get employerReviewed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JobCopyWith<Job> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobCopyWith<$Res> {
  factory $JobCopyWith(Job value, $Res Function(Job) then) =
      _$JobCopyWithImpl<$Res>;
  $Res call(
      {String? jobId,
      String title,
      String description,
      String posterUid,
      String price,
      String? photoUrl,
      dynamic geoHash,
      String locationAsName,
      List<String>? applicants,
      String status,
      String? acceptedApplicant,
      DateTime date,
      bool workerReviewed,
      bool employerReviewed});
}

/// @nodoc
class _$JobCopyWithImpl<$Res> implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._value, this._then);

  final Job _value;
  // ignore: unused_field
  final $Res Function(Job) _then;

  @override
  $Res call({
    Object? jobId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? posterUid = freezed,
    Object? price = freezed,
    Object? photoUrl = freezed,
    Object? geoHash = freezed,
    Object? locationAsName = freezed,
    Object? applicants = freezed,
    Object? status = freezed,
    Object? acceptedApplicant = freezed,
    Object? date = freezed,
    Object? workerReviewed = freezed,
    Object? employerReviewed = freezed,
  }) {
    return _then(_value.copyWith(
      jobId: jobId == freezed
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: photoUrl == freezed
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      geoHash: geoHash == freezed
          ? _value.geoHash
          : geoHash // ignore: cast_nullable_to_non_nullable
              as dynamic,
      locationAsName: locationAsName == freezed
          ? _value.locationAsName
          : locationAsName // ignore: cast_nullable_to_non_nullable
              as String,
      applicants: applicants == freezed
          ? _value.applicants
          : applicants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      acceptedApplicant: acceptedApplicant == freezed
          ? _value.acceptedApplicant
          : acceptedApplicant // ignore: cast_nullable_to_non_nullable
              as String?,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workerReviewed: workerReviewed == freezed
          ? _value.workerReviewed
          : workerReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      employerReviewed: employerReviewed == freezed
          ? _value.employerReviewed
          : employerReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$$_JobCopyWith(_$_Job value, $Res Function(_$_Job) then) =
      __$$_JobCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? jobId,
      String title,
      String description,
      String posterUid,
      String price,
      String? photoUrl,
      dynamic geoHash,
      String locationAsName,
      List<String>? applicants,
      String status,
      String? acceptedApplicant,
      DateTime date,
      bool workerReviewed,
      bool employerReviewed});
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
    Object? jobId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? posterUid = freezed,
    Object? price = freezed,
    Object? photoUrl = freezed,
    Object? geoHash = freezed,
    Object? locationAsName = freezed,
    Object? applicants = freezed,
    Object? status = freezed,
    Object? acceptedApplicant = freezed,
    Object? date = freezed,
    Object? workerReviewed = freezed,
    Object? employerReviewed = freezed,
  }) {
    return _then(_$_Job(
      jobId: jobId == freezed
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: photoUrl == freezed
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      geoHash: geoHash == freezed
          ? _value.geoHash
          : geoHash // ignore: cast_nullable_to_non_nullable
              as dynamic,
      locationAsName: locationAsName == freezed
          ? _value.locationAsName
          : locationAsName // ignore: cast_nullable_to_non_nullable
              as String,
      applicants: applicants == freezed
          ? _value._applicants
          : applicants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      acceptedApplicant: acceptedApplicant == freezed
          ? _value.acceptedApplicant
          : acceptedApplicant // ignore: cast_nullable_to_non_nullable
              as String?,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workerReviewed: workerReviewed == freezed
          ? _value.workerReviewed
          : workerReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      employerReviewed: employerReviewed == freezed
          ? _value.employerReviewed
          : employerReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Job implements _Job {
  _$_Job(
      {this.jobId,
      required this.title,
      required this.description,
      required this.posterUid,
      required this.price,
      this.photoUrl,
      required this.geoHash,
      required this.locationAsName,
      final List<String>? applicants,
      required this.status,
      this.acceptedApplicant,
      required this.date,
      required this.workerReviewed,
      required this.employerReviewed})
      : _applicants = applicants;

  factory _$_Job.fromJson(Map<String, dynamic> json) => _$$_JobFromJson(json);

  @override
  final String? jobId;
  @override
  final String title;
  @override
  final String description;
  @override
  final String posterUid;
  @override
  final String price;
  @override
  final String? photoUrl;
  @override
  final dynamic geoHash;
  @override
  final String locationAsName;
  final List<String>? _applicants;
  @override
  List<String>? get applicants {
    final value = _applicants;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String status;
// pending for inviting application
// pending -> accepted ->  in progress -> paid -> completed
  @override
  final String? acceptedApplicant;
  @override
  final DateTime date;
  @override
  final bool workerReviewed;
  @override
  final bool employerReviewed;

  @override
  String toString() {
    return 'Job(jobId: $jobId, title: $title, description: $description, posterUid: $posterUid, price: $price, photoUrl: $photoUrl, geoHash: $geoHash, locationAsName: $locationAsName, applicants: $applicants, status: $status, acceptedApplicant: $acceptedApplicant, date: $date, workerReviewed: $workerReviewed, employerReviewed: $employerReviewed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Job &&
            const DeepCollectionEquality().equals(other.jobId, jobId) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.posterUid, posterUid) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality().equals(other.photoUrl, photoUrl) &&
            const DeepCollectionEquality().equals(other.geoHash, geoHash) &&
            const DeepCollectionEquality()
                .equals(other.locationAsName, locationAsName) &&
            const DeepCollectionEquality()
                .equals(other._applicants, _applicants) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality()
                .equals(other.acceptedApplicant, acceptedApplicant) &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality()
                .equals(other.workerReviewed, workerReviewed) &&
            const DeepCollectionEquality()
                .equals(other.employerReviewed, employerReviewed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(jobId),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(posterUid),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(photoUrl),
      const DeepCollectionEquality().hash(geoHash),
      const DeepCollectionEquality().hash(locationAsName),
      const DeepCollectionEquality().hash(_applicants),
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(acceptedApplicant),
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(workerReviewed),
      const DeepCollectionEquality().hash(employerReviewed));

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
      {final String? jobId,
      required final String title,
      required final String description,
      required final String posterUid,
      required final String price,
      final String? photoUrl,
      required final dynamic geoHash,
      required final String locationAsName,
      final List<String>? applicants,
      required final String status,
      final String? acceptedApplicant,
      required final DateTime date,
      required final bool workerReviewed,
      required final bool employerReviewed}) = _$_Job;

  factory _Job.fromJson(Map<String, dynamic> json) = _$_Job.fromJson;

  @override
  String? get jobId => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  String get posterUid => throw _privateConstructorUsedError;
  @override
  String get price => throw _privateConstructorUsedError;
  @override
  String? get photoUrl => throw _privateConstructorUsedError;
  @override
  dynamic get geoHash => throw _privateConstructorUsedError;
  @override
  String get locationAsName => throw _privateConstructorUsedError;
  @override
  List<String>? get applicants => throw _privateConstructorUsedError;
  @override
  String get status => throw _privateConstructorUsedError;
  @override // pending for inviting application
// pending -> accepted ->  in progress -> paid -> completed
  String? get acceptedApplicant => throw _privateConstructorUsedError;
  @override
  DateTime get date => throw _privateConstructorUsedError;
  @override
  bool get workerReviewed => throw _privateConstructorUsedError;
  @override
  bool get employerReviewed => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_JobCopyWith<_$_Job> get copyWith => throw _privateConstructorUsedError;
}
