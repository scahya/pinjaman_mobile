class PinjamanModel {
  final String id;
  final String idNasabah;
  final UserModel? approvedByUser;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String nik;
  final String namaLengkap;
  final String alamat;
  final String? noTelpon;
  final double jumlahPinjaman;
  final String status;
  final String? catatanAdmin;

  PinjamanModel({
    required this.id,
    required this.idNasabah,
    required this.approvedByUser,
    required this.createdAt,
    required this.approvedAt,
    required this.nik,
    required this.namaLengkap,
    required this.alamat,
    required this.noTelpon,
    required this.jumlahPinjaman,
    required this.status,
    required this.catatanAdmin,
  });

  factory PinjamanModel.fromJson(Map<String, dynamic> json) {
    return PinjamanModel(
      id: json['id'],
      idNasabah: json['idNasabah'],
      approvedByUser: json['approvedByUser'] != null
          ? UserModel.fromJson(json['approvedByUser'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      nik: json['nik'],
      namaLengkap: json['namaLengkap'],
      alamat: json['alamat'],
      noTelpon: json['noTelpon'],
      jumlahPinjaman: (json['jumlahPinjaman'] as num).toDouble(),
      status: json['status'],
      catatanAdmin: json['catatanAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idNasabah': idNasabah,
      'approvedByUser': approvedByUser?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'nik': nik,
      'namaLengkap': namaLengkap,
      'alamat': alamat,
      'noTelpon': noTelpon,
      'jumlahPinjaman': jumlahPinjaman,
      'status': status,
      'catatanAdmin': catatanAdmin,
    };
  }
}

/// ==========================
/// USER MODEL
/// ==========================
class UserModel {
  final String id;
  final String namaLengkap;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.namaLengkap,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      namaLengkap: json['namaLengkap'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaLengkap': namaLengkap,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
