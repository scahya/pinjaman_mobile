import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  String? token;
  bool loading = false;
  String? errorMessage;

  AuthProvider(this.authService);

  Future<bool> login(String username, String password) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await authService.login(username, password);

      if (res == null || res["token"] == null) {
        errorMessage = "Invalid response from server";
        loading = false;
        notifyListeners();
        return false;
      }

      token = res["token"];

      // Save token ke SharedPreferences
      final sp = await SharedPreferences.getInstance();
      await sp.setString("jwt_token", token!);

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String username,
    String password,
    String namaLengkap,
  ) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await authService.register(username, password, namaLengkap);

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> loadTokenFromStorage() async {
    final sp = await SharedPreferences.getInstance();
    token = sp.getString("jwt_token");
    notifyListeners();
  }

  Future<void> logout() async {
    token = null;
    final sp = await SharedPreferences.getInstance();
    await sp.remove("jwt_token");
    notifyListeners();
  }
}
