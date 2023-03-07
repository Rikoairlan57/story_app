import 'dart:convert';

class Common {
  final bool error;
  final String message;

  Common({
    required this.error,
    required this.message,
  });

  factory Common.fromMap(Map<String, dynamic> map) {
    return Common(
      error: map['error'] ?? false,
      message: map['message'] ?? "",
    );
  }

  factory Common.fromJson(String source) => Common.fromMap(
        json.decode(source),
      );
}
