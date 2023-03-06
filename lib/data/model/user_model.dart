import 'dart:convert';

class UserModel {
  UserModel({
    required this.userId,
    required this.name,
    required this.token,
  });

  String? userId;
  String? name;
  String? token;

  @override
  String toString() => 'User(userId: $userId, name:$name, token: $token)';

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
