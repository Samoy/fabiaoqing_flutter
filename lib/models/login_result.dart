import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
    LoginResult();

    String userId;
    String token;
    
    factory LoginResult.fromJson(Map<String,dynamic> json) => _$LoginResultFromJson(json);
    Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
