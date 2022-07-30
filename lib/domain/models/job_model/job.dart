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
    required String price,
    String? photoUrl,
    required dynamic geoHash,
    required String locationAsName,
    List<String>? applicants,
    required String status, // pending for inviting application
    // pending -> accepted ->  in progress -> paid -> completed
    String? acceptedApplicant,
    required bool workerReviewed,
    required bool employerReviewed,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
