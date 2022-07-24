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
      photoUrl: json['photoUrl'] as String?,
      geoHash: json['geoHash'],
      applicants: (json['applicants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      acceptedApplicant: json['acceptedApplicant'] as String?,
    );

Map<String, dynamic> _$$_JobToJson(_$_Job instance) => <String, dynamic>{
      'jobId': instance.jobId,
      'title': instance.title,
      'description': instance.description,
      'posterUid': instance.posterUid,
      'photoUrl': instance.photoUrl,
      'geoHash': instance.geoHash,
      'applicants': instance.applicants,
      'status': instance.status,
      'acceptedApplicant': instance.acceptedApplicant,
    };
