// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'profilePicture': instance.profilePicture,
    };
