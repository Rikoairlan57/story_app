import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/result_state.dart';
import 'package:story_app/data/response/story_list.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiService apiService;

  StoryListProvider({required this.apiService}) {
    _fetchStories();
  }

  late StoryList _storyList;
  StoryList get list => _storyList;

  late ResultState _state;
  ResultState get state => _state;

  late String _message;
  String get message => _message;

  Future<dynamic> _fetchStories() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final response = await apiService.fetchStories();
      if (response.listStory.isEmpty) {
        _state = ResultState.hasData;
        _storyList = response;
        notifyListeners();
        return _storyList;
      } else if (response.listStory.isEmpty) {
        _state = ResultState.noData;
        _message = response.message;
        notifyListeners();
        return _message;
      } else {
        _state = ResultState.error;
        _message = response.message;
        notifyListeners();
        return _message;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
      return _message;
    }
  }
}
