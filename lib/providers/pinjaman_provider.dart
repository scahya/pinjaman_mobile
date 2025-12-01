import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pinjaman_mobile/api/pinjaman_service.dart';
import 'package:pinjaman_mobile/models/pinjaman.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PinjamanProvider extends ChangeNotifier {
  final PinjamanService pinjamanService;
  List<PinjamanModel> pinjamanList = [];
  bool loading = false;
  String? errorMessage;

  PinjamanProvider(this.pinjamanService);

  Future<void> fetchPinjamanList() async {
    loading = true;
    // notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString("role");
      print('Role: $role');

      pinjamanList = (role == "Admin")
          ? await pinjamanService.getAllPengajuan()
          : await pinjamanService.getMyPengajuan();

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<bool> postAjukanPinjaman(
    String nik,
    String alamat,
    String noTelepon,
    int jumlahPinjaman,
  ) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await pinjamanService.ajukan(
        nik,
        alamat,
        noTelepon,
        jumlahPinjaman,
      );
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

  Future<bool> putApproveRejectPinjaman(
    String id,
    String catatanAdmin,
    String status,
  ) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await pinjamanService.approveReject(id, catatanAdmin, status);
      loading = false;
      notifyListeners();
      await fetchPinjamanList();

      return true;
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clear() {
    pinjamanList = [];
    notifyListeners();
  }
}
