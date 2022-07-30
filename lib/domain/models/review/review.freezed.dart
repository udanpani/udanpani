// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get reviewUid => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String get review => throw _privateConstructorUsedError;
  String get reviewedUid => throw _privateConstructorUsedError;
  String get reviewerUid => throw _privateConstructorUsedError;
  String get reviewerUname => throw _privateConstructorUsedError;
  String get jobID => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res>;
  $Res call(
      {String reviewUid,
      double rating,
      String review,
      String reviewedUid,
      String reviewerUid,
      String reviewerUname,
      String jobID});
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res> implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  final Review _value;
  // ignore: unused_field
  final $Res Function(Review) _then;

  @override
  $Res call({
    Object? reviewUid = freezed,
    Object? rating = freezed,
    Object? review = freezed,
    Object? reviewedUid = freezed,
    Object? reviewerUid = freezed,
    Object? reviewerUname = freezed,
    Object? jobID = freezed,
  }) {
    return _then(_value.copyWith(
      reviewUid: reviewUid == freezed
          ? _value.reviewUid
          : reviewUid // ignore: cast_nullable_to_non_nullable
              as String,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      review: review == freezed
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedUid: reviewedUid == freezed
          ? _value.reviewedUid
          : reviewedUid // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerUid: reviewerUid == freezed
          ? _value.reviewerUid
          : reviewerUid // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerUname: reviewerUname == freezed
          ? _value.reviewerUname
          : reviewerUname // ignore: cast_nullable_to_non_nullable
              as String,
      jobID: jobID == freezed
          ? _value.jobID
          : jobID // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$_ReviewCopyWith(_$_Review value, $Res Function(_$_Review) then) =
      __$$_ReviewCopyWithImpl<$Res>;
  @override
  $Res call(
      {String reviewUid,
      double rating,
      String review,
      String reviewedUid,
      String reviewerUid,
      String reviewerUname,
      String jobID});
}

/// @nodoc
class __$$_ReviewCopyWithImpl<$Res> extends _$ReviewCopyWithImpl<$Res>
    implements _$$_ReviewCopyWith<$Res> {
  __$$_ReviewCopyWithImpl(_$_Review _value, $Res Function(_$_Review) _then)
      : super(_value, (v) => _then(v as _$_Review));

  @override
  _$_Review get _value => super._value as _$_Review;

  @override
  $Res call({
    Object? reviewUid = freezed,
    Object? rating = freezed,
    Object? review = freezed,
    Object? reviewedUid = freezed,
    Object? reviewerUid = freezed,
    Object? reviewerUname = freezed,
    Object? jobID = freezed,
  }) {
    return _then(_$_Review(
      reviewUid: reviewUid == freezed
          ? _value.reviewUid
          : reviewUid // ignore: cast_nullable_to_non_nullable
              as String,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      review: review == freezed
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedUid: reviewedUid == freezed
          ? _value.reviewedUid
          : reviewedUid // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerUid: reviewerUid == freezed
          ? _value.reviewerUid
          : reviewerUid // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerUname: reviewerUname == freezed
          ? _value.reviewerUname
          : reviewerUname // ignore: cast_nullable_to_non_nullable
              as String,
      jobID: jobID == freezed
          ? _value.jobID
          : jobID // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Review implements _Review {
  _$_Review(
      {required this.reviewUid,
      required this.rating,
      required this.review,
      required this.reviewedUid,
      required this.reviewerUid,
      required this.reviewerUname,
      required this.jobID});

  factory _$_Review.fromJson(Map<String, dynamic> json) =>
      _$$_ReviewFromJson(json);

  @override
  final String reviewUid;
  @override
  final double rating;
  @override
  final String review;
  @override
  final String reviewedUid;
  @override
  final String reviewerUid;
  @override
  final String reviewerUname;
  @override
  final String jobID;

  @override
  String toString() {
    return 'Review(reviewUid: $reviewUid, rating: $rating, review: $review, reviewedUid: $reviewedUid, reviewerUid: $reviewerUid, reviewerUname: $reviewerUname, jobID: $jobID)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Review &&
            const DeepCollectionEquality().equals(other.reviewUid, reviewUid) &&
            const DeepCollectionEquality().equals(other.rating, rating) &&
            const DeepCollectionEquality().equals(other.review, review) &&
            const DeepCollectionEquality()
                .equals(other.reviewedUid, reviewedUid) &&
            const DeepCollectionEquality()
                .equals(other.reviewerUid, reviewerUid) &&
            const DeepCollectionEquality()
                .equals(other.reviewerUname, reviewerUname) &&
            const DeepCollectionEquality().equals(other.jobID, jobID));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(reviewUid),
      const DeepCollectionEquality().hash(rating),
      const DeepCollectionEquality().hash(review),
      const DeepCollectionEquality().hash(reviewedUid),
      const DeepCollectionEquality().hash(reviewerUid),
      const DeepCollectionEquality().hash(reviewerUname),
      const DeepCollectionEquality().hash(jobID));

  @JsonKey(ignore: true)
  @override
  _$$_ReviewCopyWith<_$_Review> get copyWith =>
      __$$_ReviewCopyWithImpl<_$_Review>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReviewToJson(this);
  }
}

abstract class _Review implements Review {
  factory _Review(
      {required final String reviewUid,
      required final double rating,
      required final String review,
      required final String reviewedUid,
      required final String reviewerUid,
      required final String reviewerUname,
      required final String jobID}) = _$_Review;

  factory _Review.fromJson(Map<String, dynamic> json) = _$_Review.fromJson;

  @override
  String get reviewUid => throw _privateConstructorUsedError;
  @override
  double get rating => throw _privateConstructorUsedError;
  @override
  String get review => throw _privateConstructorUsedError;
  @override
  String get reviewedUid => throw _privateConstructorUsedError;
  @override
  String get reviewerUid => throw _privateConstructorUsedError;
  @override
  String get reviewerUname => throw _privateConstructorUsedError;
  @override
  String get jobID => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ReviewCopyWith<_$_Review> get copyWith =>
      throw _privateConstructorUsedError;
}
