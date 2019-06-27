// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoticon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emoticon _$EmoticonFromJson(Map<String, dynamic> json) {
  return Emoticon()
    ..objectId = json['objectId'] as String
    ..name = json['name'] as String
    ..url = json['url'] as String;
}

Map<String, dynamic> _$EmoticonToJson(Emoticon instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'name': instance.name,
      'url': instance.url
    };
