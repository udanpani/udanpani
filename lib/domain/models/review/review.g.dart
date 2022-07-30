// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Review _$$_ReviewFromJson(Map<String, dynamic> json) => _$_Review(
      reviewUid: json['reviewUid'] as String,
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] as String,
      reviewedUid: json['reviewedUid'] as String,
      reviewerUid: json['reviewerUid'] as String,
      reviewerUname: json['reviewerUname'] as String,
      jobID: json['jobID'] as String,
    );

Map<String, dynamic> _$$_ReviewToJson(_$_Review instance) => <String, dynamic>{
      'reviewUid': instance.reviewUid,
      'rating': instance.rating,
      'review': instance.review,
      'reviewedUid': instance.reviewedUid,
      'reviewerUid': instance.reviewerUid,
      'reviewerUname': instance.reviewerUname,
      'jobID': instance.jobID,
    };
