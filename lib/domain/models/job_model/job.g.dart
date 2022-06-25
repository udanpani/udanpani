// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Job _$$_JobFromJson(Map<String, dynamic> json) => _$_Job(
      title: json['title'] as String,
      description: json['description'] as String,
      posterUid: json['posterUid'] as String,
      locX: json['locX'] as String,
      locY: json['locY'] as String,
      applicants: (json['applicants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$_JobToJson(_$_Job instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'posterUid': instance.posterUid,
      'locX': instance.locX,
      'locY': instance.locY,
      'applicants': instance.applicants,
    };
