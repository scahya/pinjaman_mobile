import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Future<String?> _getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('jwt_token');
  }

  Future<http.Response> post(
    String path,
    Map body, {
    Map<String, String>? headers,
  }) async {
    final token = await _getToken();
    final h = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (headers != null) ...headers,
    };
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: h,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String path) async {
    final token = await _getToken();
    final h = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return http.get(Uri.parse('$baseUrl$path'), headers: h);
  }

  Future<http.Response> put(String path, Map body) async {
    final token = await _getToken();
    final h = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return http.put(
      Uri.parse('$baseUrl$path'),
      headers: h,
      body: jsonEncode(body),
    );
  }
}
