class CreateStoryResponseModel {
  CreateStoryResponseModel({
    required this.error,
    required this.message,
  });

  final bool error;
  final String message;

  factory CreateStoryResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateStoryResponseModel(
        error: json["error"],
        message: json["message"],
      );
}
