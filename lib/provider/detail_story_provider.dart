import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/result_state.dart';
import 'package:story_app/data/response/story_detail.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  DetailStoryProvider({required this.apiService, required this.id}) {
    _fetchStoryDetail(id);
  }

  late StoryDetail _storyDetail;
  StoryDetail get story => _storyDetail;

  late ResultState _state;
  ResultState get state => _state;

  late String _message;
  String get message => _message;

  Future<dynamic> _fetchStoryDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final data = await apiService.fetchStoryDetail(id);

      if (!data.error) {
        _state = ResultState.hasData;
        _storyDetail = data;
        notifyListeners();
        return _storyDetail;
      } else {
        _state = ResultState.error;
        _message = data.message;
        notifyListeners();
        return _message;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = "Error --> $e";
      notifyListeners();
      return _message;
    }
  }
}
