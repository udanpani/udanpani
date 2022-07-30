// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      uid: json['uid'] as String?,
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      addressProof: json['addressProof'] as String?,
      verifications: json['verifications'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      noOfReviews: json['noOfReviews'] as int?,
      reviews:
          (json['reviews'] as List<dynamic>?)?.map((e) => e as String).toList(),
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'addressProof': instance.addressProof,
      'verifications': instance.verifications,
      'rating': instance.rating,
      'noOfReviews': instance.noOfReviews,
      'reviews': instance.reviews,
      'profilePicture': instance.profilePicture,
    };
