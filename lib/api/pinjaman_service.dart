import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class PinjamanService {
  final ApiClient client;
  PinjamanService(this.client);

  Future<List> getMyPengajuan() async {
    final res = await client.get('/api/pinjaman/nasabah');
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Gagal ambil pengajuan');
  }

  Future<List> getAllPengajuan() async {
    final res = await client.get('/api/pinjaman/list');
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Gagal ambil semua pengajuan');
  }

  Future<Map?> ajukan(
    String nik,
    String alamat,
    String noTelepon,
    int jumlahPinjaman,
  ) async {
    final res = await client.post('/api/pinjaman/ajukan', {
      "nik": nik,
      "alamat": alamat,
      "noTelepon": noTelepon,
      "jumlahPinjaman": jumlahPinjaman,
    });
    return jsonDecode(res.body);
  }

  Future<Map?> approveReject(
    String id,
    String catatanAdmin,
    String status,
  ) async {
    final res = await client.put('/api/pinjaman/$id/approve', {
      'status': status,
      'catatanAdmin': catatanAdmin ?? '',
    });
    return jsonDecode(res.body);
  }

  getPinjamanNasabah() async {}
}
