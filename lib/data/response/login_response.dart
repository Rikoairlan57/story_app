import 'dart:convert';

import 'package:story_app/data/model/user_model.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  bool error;
  String message;
  UserModel loginResult;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        error: json["error"],
        message: json["message"],
        loginResult: UserModel.fromJson(jsonEncode(json["loginResult"])),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult.toJson(),
      };
}
