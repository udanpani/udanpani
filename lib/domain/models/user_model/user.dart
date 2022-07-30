import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    String? uid,
    required String username,
    required String name,
    required String email,
    required String phoneNumber,
    String? addressProof,
    String? verifications,
    double? rating,
    int? noOfReviews,
    List<String>? reviews,
    String? profilePicture,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
