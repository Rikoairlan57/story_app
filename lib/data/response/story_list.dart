import 'dart:convert';

import 'package:story_app/data/model/story_model.dart';

StoryList storyListFromJson(String str) => StoryList.fromJson(json.decode(str));

String storyListToJson(StoryList data) => json.encode(data.toJson());

class StoryList {
  StoryList({
    required this.error,
    required this.message,
    required this.listStory,
  });

  bool error;
  String message;
  List<StoryModel> listStory;

  factory StoryList.fromJson(Map<String, dynamic> json) => StoryList(
        error: json["error"],
        message: json["message"],
        listStory: List<StoryModel>.from(
            json["listStory"].map((x) => StoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };
}
