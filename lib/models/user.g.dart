// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..objectId = json['objectId'] as String
    ..email = json['email'] as String
    ..telephone = json['telephone'] as String
    ..nickname = json['nickname'] as String
    ..sex = json['sex'] as bool
    ..avatar = json['avatar'] as String
    ..description = json['description'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'email': instance.email,
      'telephone': instance.telephone,
      'nickname': instance.nickname,
      'sex': instance.sex,
      'avatar': instance.avatar,
      'description': instance.description
    };
