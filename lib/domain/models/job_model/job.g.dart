// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Job _$$_JobFromJson(Map<String, dynamic> json) => _$_Job(
      jobId: json['jobId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      posterUid: json['posterUid'] as String,
      price: json['price'] as String,
      photoUrl: json['photoUrl'] as String?,
      geoHash: json['geoHash'],
      locationAsName: json['locationAsName'] as String,
      applicants: (json['applicants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      acceptedApplicant: json['acceptedApplicant'] as String?,
      date: DateTime.parse(json['date'] as String),
      workerReviewed: json['workerReviewed'] as bool,
      employerReviewed: json['employerReviewed'] as bool,
    );

Map<String, dynamic> _$$_JobToJson(_$_Job instance) => <String, dynamic>{
      'jobId': instance.jobId,
      'title': instance.title,
      'description': instance.description,
      'posterUid': instance.posterUid,
      'price': instance.price,
      'photoUrl': instance.photoUrl,
      'geoHash': instance.geoHash,
      'locationAsName': instance.locationAsName,
      'applicants': instance.applicants,
      'status': instance.status,
      'acceptedApplicant': instance.acceptedApplicant,
      'date': instance.date.toIso8601String(),
      'workerReviewed': instance.workerReviewed,
      'employerReviewed': instance.employerReviewed,
    };
