import 'package:json_annotation/json_annotation.dart';
import "emoticon.dart";
part 'package.g.dart';

@JsonSerializable()
class Package {
    Package();

    String objectId;
    String name;
    num count;
    List<Emoticon> list;
    
    factory Package.fromJson(Map<String,dynamic> json) => _$PackageFromJson(json);
    Map<String, dynamic> toJson() => _$PackageToJson(this);
}
