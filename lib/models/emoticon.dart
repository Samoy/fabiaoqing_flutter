import 'package:json_annotation/json_annotation.dart';

part 'emoticon.g.dart';

@JsonSerializable()
class Emoticon {
    Emoticon();

    String objectId;
    String name;
    String url;
    
    factory Emoticon.fromJson(Map<String,dynamic> json) => _$EmoticonFromJson(json);
    Map<String, dynamic> toJson() => _$EmoticonToJson(this);
}
