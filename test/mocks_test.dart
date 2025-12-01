import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:pinjaman_mobile/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([http.Client, SharedPreferences, ApiClient])
void main() {}
