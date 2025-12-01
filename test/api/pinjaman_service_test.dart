import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:pinjaman_mobile/api/pinjaman_service.dart';

import '../mocks_test.mocks.dart';
import 'package:pinjaman_mobile/models/pinjaman.dart';

void main() {
  late MockApiClient mockApi;
  late PinjamanService service;

  setUp(() {
    mockApi = MockApiClient();
    service = PinjamanService(mockApi);
  });

  test("getMyPengajuan returns list of PinjamanModel", () async {
    final jsonString = jsonEncode([
      {
        "id": "123",
        "idNasabah": "abc",
        "jumlahPinjaman": 1000000,
        "status": "Pending",
      },
    ]);

    when(
      mockApi.get('/api/pinjaman/nasabah'),
    ).thenAnswer((_) async => http.Response(jsonString, 200));

    final result = await service.getMyPengajuan();

    expect(result.length, 1);
    expect(result.first.id, "123");
    expect(result.first.status, "Pending");
  });

  test("getMyPengajuan throws exception on non-200", () async {
    when(
      mockApi.get('/api/pinjaman/nasabah'),
    ).thenAnswer((_) async => http.Response("Error", 400));

    expect(() => service.getMyPengajuan(), throwsException);
  });

  test("getAllPengajuan returns list", () async {
    when(
      mockApi.get('/api/pinjaman/list'),
    ).thenAnswer((_) async => http.Response(jsonEncode([]), 200));

    final result = await service.getAllPengajuan();
    expect(result, isA<List<PinjamanModel>>());
  });

  test("ajukan returns decoded JSON", () async {
    when(mockApi.post('/api/pinjaman/ajukan', any)).thenAnswer(
      (_) async => http.Response(jsonEncode({"success": true}), 200),
    );

    final result = await service.ajukan("nik123", "alamat", "telp", 3000000);

    expect(result?["success"], true);
  });

  test("approveReject returns decoded JSON", () async {
    when(mockApi.put('/api/pinjaman/123/approve', any)).thenAnswer(
      (_) async => http.Response(jsonEncode({"status": "Approved"}), 200),
    );

    final result = await service.approveReject("123", "ok", "Approved");

    expect(result?["status"], "Approved");
  });
}
