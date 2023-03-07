import 'dart:convert';

import 'package:story_app/data/model/story_model.dart';

StoryDetail storyDetailFromJson(String str) =>
    StoryDetail.fromJson(json.decode(str));

String storyDetailToJson(StoryDetail data) => json.encode(data.toJson());

class StoryDetail {
  StoryDetail({
    required this.error,
    required this.message,
    required this.story,
  });

  bool error;
  String message;
  StoryModel story;

  factory StoryDetail.fromJson(Map<String, dynamic> json) => StoryDetail(
        error: json["error"],
        message: json["message"],
        story: StoryModel.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}
