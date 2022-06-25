import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class Job with _$Job {
  factory Job({
    required String title,
    required String description,
    required String posterUid,
    required String locX,
    required String locY,
    List<String>? applicants,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
