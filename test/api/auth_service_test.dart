import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';
import 'package:pinjaman_mobile/services/auth_service.dart';

void main() {
  late MockApiClient mockClient;
  late AuthService auth;

  setUp(() {
    mockClient = MockApiClient();
    auth = AuthService(mockClient);
  });

  group('AuthService.login', () {
    test('returns body when status 200', () async {
      when(mockClient.post("/api/auth/login", any))
          .thenAnswer((_) async => MockHttpResponse(200, '{"token":"abc"}'));
 
      final result = await auth.login("user", "pass");

      expect(result, isNotNull);
      expect(result!["token"], "abc");
    });

    test('throws exception when status != 200', () async {
      when(mockClient.post("/api/auth/login", any))
          .thenAnswer((_) async => MockHttpResponse(400, '{"message":"Invalid"}'));

      expect(
        () async => await auth.login("user", "wrong"),
        throwsException,
      );
    });
  });

  group('AuthService.register', () {
    test('returns body when status 200', () async {
      when(mockClient.post("/api/auth/register", any))
          .thenAnswer((_) async => MockHttpResponse(200, '{"success":true}'));

      final result = await auth.register("u", "p", "Nama", "USER");

      expect(result, isA<Map>());
      expect(result!["success"], true);
    });
  });
}

/// helper mock response
class MockHttpResponse extends Fake implements http.Response {
  @override
  final int statusCode;

  @override
  final String body;

  MockHttpResponse(this.statusCode, this.body);
}
