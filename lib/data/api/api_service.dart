import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/data/response/common.dart';
import 'package:story_app/data/response/login_response.dart';
import 'package:story_app/data/response/story_detail.dart';
import 'package:story_app/data/response/story_list.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  final AuthRepository authRepository = AuthRepository();

  Future<Common> register(String name, String email, String password) async {
    final endPointUri = Uri.parse("$_baseUrl/register");
    final Map<String, String> fields = {
      "name": name,
      "email": email,
      "password": password
    };

    final response = await http.post(endPointUri, body: fields);

    if (response.statusCode == 200) {
      final Common common = Common.fromJson(response.body);
      return common;
    } else {
      final Common common = Common.fromJson(response.body);
      throw Exception(common.message);
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final endPointUri = Uri.parse("$_baseUrl/login");
    final Map<String, String> fields = {
      "email": email,
      "password": "password",
    };

    final response = await http.post(endPointUri, body: fields);
    if (response.statusCode == 200) {
      return loginResponseFromJson(response.body);
    } else {
      throw Exception('Failed to Login');
    }
  }

  Future<StoryList> fetchStories() async {
    final endPointUri = Uri.parse("$_baseUrl/stories");
    final user = await authRepository.getUser();
    final response = await http.get(
      endPointUri,
      headers: {HttpHeaders.authorizationHeader: "Bearer ${user!.token}"},
    );

    if (response.statusCode == 200) {
      return storyListFromJson(response.body);
    } else {
      final StoryList storyList = storyListFromJson(response.body);
      throw Exception(storyList.message);
    }
  }

  Future<StoryDetail> fetchStoryDetail(String id) async {
    final endPointUri = Uri.parse('$_baseUrl/stories/$id');
    final user = await authRepository.getUser();
    final response = await http.get(
      endPointUri,
      headers: {HttpHeaders.authorizationHeader: "Bearer ${user!.token}"},
    );

    if (response.statusCode == 200) {
      return storyDetailFromJson(response.body);
    } else {
      final StoryDetail storyDetail = storyDetailFromJson(response.body);
      throw Exception(storyDetail.message);
    }
  }

  Future<Common> storeStory(
      List<int> bytes, String fileName, String description) async {
    final endPointUri = Uri.parse('$_baseUrl/stories');
    final user = await authRepository.getUser();

    final request = http.MultipartRequest('POST', endPointUri);
    final multiPartFile =
        http.MultipartFile.fromBytes('photo', bytes, filename: fileName);

    final Map<String, String> fields = {
      "description": description,
    };
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer ${user!.token}",
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final Common commonResponse = Common.fromJson(
        responseData,
      );
      return commonResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
