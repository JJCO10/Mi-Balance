import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? user;

  Future<bool> login(String email, String password) async {
    user = await _authService.login(email, password);
    notifyListeners();
    return user != null;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String nickname,
    required String gender,
  }) async {
    user = await _authService.register(
      email: email,
      password: password,
      name: name,
      nickname: nickname,
      gender: gender,
    );
    notifyListeners();
    return user != null;
  }

  void logout() {
    _authService.logout();
    user = null;
    notifyListeners();
  }
}
