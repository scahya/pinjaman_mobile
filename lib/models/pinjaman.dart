class Pinjaman {
  final String id;
  final String nik;
  final String nama;
  final String alamat;
  final String telp;
  final int jumlah;
  final String status;
  final String? note;

  Pinjaman({
    required this.id,
    required this.nik,
    required this.nama,
    required this.alamat,
    required this.telp,
    required this.jumlah,
    required this.status,
    this.note,
  });

  factory Pinjaman.fromJson(Map json) => Pinjaman(
    id: json['id'].toString(),
    nik: json['nik'],
    nama: json['nama'],
    alamat: json['alamat'],
    telp: json['telp'],
    jumlah: json['jumlah'],
    status: json['status'],
    note: json['note'],
  );
}
