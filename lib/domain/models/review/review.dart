import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  factory Review({
    required String reviewUid,
    required double rating,
    required String review,
    required String reviewedUid,
    required String reviewerUid,
    required String reviewerUname,
    required String jobID,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
