import 'package:image_picker/image_picker.dart';

class CreateStoryRequestModel {
  final String description;
  final XFile image;

  CreateStoryRequestModel({
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}
