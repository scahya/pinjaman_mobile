import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pinjaman_mobile/api/pinjaman_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PinjamanProvider extends ChangeNotifier {
  final PinjamanService pinjamanService;
  List<dynamic> pinjamanList = [];
  bool loading = false;
  String? errorMessage;

  PinjamanProvider(this.pinjamanService);

  Future<void> fetchPinjamanList() async {
    loading = true;
    errorMessage = null;
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString("role");
    print('The value of x is: $role');

    // notifyListeners();
    try {
      if (role == "Admin") {
        pinjamanList = await pinjamanService.getAllPengajuan();
      } else {
        pinjamanList = await pinjamanService.getMyPengajuan();
      }

      // pinjamanList = await pinjamanService.getMyPengajuan();
      loading = false;
      errorMessage = null;
      notifyListeners();
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
