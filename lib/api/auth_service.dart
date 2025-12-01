import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final ApiClient client;
  AuthService(this.client);

  Future<Map?> login(String username, String password) async {
    final res = await client.post("/api/auth/login", {
      "username": username,
      "password": password,
    });

    final body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return body; // return { token: "xxx" }
    } else {
      throw Exception(body["message"] ?? "Login failed");
    }
  }

  Future<Map?> register(
    String username,
    String password,
    String namaLengkap,
    String role,
  ) async {
    final res = await client.post("/api/auth/register", {
      "username": username,
      "password": password,
      "namaLengkap": namaLengkap,
      "role": role,
    });

    final body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return body;
    } else {
      throw Exception(body["message"] ?? "Register failed");
    }
  }

  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('jwt_token');
  }

  Map? _handleResponse(http.Response res) {
    final data = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    return {'error': data};
  }
}
