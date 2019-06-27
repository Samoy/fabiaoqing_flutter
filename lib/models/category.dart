import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
    Category();

    String objectId;
    String name;
    
    factory Category.fromJson(Map<String,dynamic> json) => _$CategoryFromJson(json);
    Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
