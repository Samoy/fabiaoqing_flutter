// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) {
  return Package()
    ..objectId = json['objectId'] as String
    ..name = json['name'] as String
    ..count = json['count'] as num
    ..list = (json['list'] as List)
        ?.map((e) =>
            e == null ? null : Emoticon.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'name': instance.name,
      'count': instance.count,
      'list': instance.list
    };
