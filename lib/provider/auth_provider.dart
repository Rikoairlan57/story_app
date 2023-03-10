import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/data/response/common_response.dart';
import 'package:story_app/data/response/login_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  AuthProvider(this.authRepository, this.apiService);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  String message = "";
  CommonResponse? commonResponse;
  LoginResponse? loginResponse;

  Future<void> login(String email, String password) async {
    try {
      isLoadingLogin = true;
      loginResponse = null;
      notifyListeners();

      loginResponse = await apiService.login(email, password);
      message = loginResponse?.message ?? 'success';
      await authRepository.saveUser(loginResponse!.loginResult);
      await authRepository.login();
      isLoadingLogin = false;
      notifyListeners();
    } catch (e) {
      isLoadingLogin = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<void> register(String name, String email, String password) async {
    try {
      message = "";
      commonResponse = null;
      isLoadingRegister = true;
      notifyListeners();

      commonResponse = await apiService.register(name, email, password);
      message = commonResponse?.message ?? 'success';
      isLoadingRegister = false;
      notifyListeners();
    } catch (e) {
      isLoadingRegister = false;
      message = e.toString();
      notifyListeners();
    }
  }
}
