import 'package:flutter/material.dart';
import 'package:story_app/data/common/enum/result_state.dart';
import 'package:story_app/data/model/response/list_story_model.dart';
import 'package:story_app/data/service/api_service.dart';
import 'package:story_app/data/service/auth_service.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthService _authService;
  final String _storyId;

  DetailProvider({
    required ApiService apiService,
    required AuthService authService,
    required String storyId,
  })  : _apiService = apiService,
        _authService = authService,
        _storyId = storyId {
    _getStory();
  }

  late ListStory _listStory;
  late ResultState _state;

  ResultState get state => _state;

  ListStory get listStory => _listStory;

  Future<void> _getStory() async {
    _state = ResultState.loading;
    notifyListeners();

    final userData = await _authService.getUserData();

    if (userData != null) {
      try {
        final res = await _apiService.getStoryDetail(userData.token, _storyId);

        if (res.listStory != null) {
          _listStory = res.listStory!;
          _state = ResultState.hasData;
        } else {
          _state = ResultState.noData;
        }
      } catch (e) {
        _state = ResultState.error;
      }
    } else {
      _state = ResultState.noData;
    }

    notifyListeners();
  }

  Future<void> refreshData() async {
    await _getStory();
  }
}
