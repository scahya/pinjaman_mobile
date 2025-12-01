final RegExp nikReg = RegExp(r'^\d{16}$');
// Indonesia mobile: +62 or 0 then 8... (approx)
final RegExp phoneReg = RegExp(r'^(\+62|0)8[1-9][0-9]{6,9}$');

String? validateNIK(String? v) {
  if (v == null || v.isEmpty) return 'NIK wajib diisi';
  if (!nikReg.hasMatch(v)) return 'NIK harus 16 digit angka';
  return null;
}

String? validatePhone(String? v) {
  if (v == null || v.isEmpty) return 'No telp wajib diisi';
  if (!phoneReg.hasMatch(v))
    return 'Format nomor telepon tidak valid (Indonesia)';
  return null;
}

String? validateJumlah(String? v) {
  if (v == null || v.isEmpty) return 'Jumlah wajib diisi';
  final num? n = int.tryParse(v.replaceAll(',', ''));
  if (n == null) return 'Masukkan angka saja';
  if (n < 1000000) return 'Jumlah minimal 1.000.000';
  return null;
}
