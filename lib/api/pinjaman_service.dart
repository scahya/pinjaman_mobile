import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<Map?> ajukan(Map payload) async {
    final res = await client.post('/api/pinjaman/ajukan', payload);
    return jsonDecode(res.body);
  }

  Future<Map?> approveReject(String id, String status, {String? note}) async {
    final res = await client.put('/api/pinjaman/$id/approve', {
      'status': status,
      'note': note ?? '',
    });
    return jsonDecode(res.body);
  }
}
