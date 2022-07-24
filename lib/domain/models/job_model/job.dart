import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class Job with _$Job {
  factory Job({
    String? jobId,
    required String title,
    required String description,
    required String posterUid,
    String? photoUrl,
    required dynamic geoHash,
    List<String>? applicants,
    required String status, // pending for inviting application
    // pending -> accepted ->  in progress -> completed
    String? acceptedApplicant,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
