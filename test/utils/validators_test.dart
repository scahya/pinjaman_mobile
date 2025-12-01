import 'package:test/test.dart';
import 'package:pinjaman_mobile/utils/validators.dart';

void main() {
  group('validateNIK', () {
    test('should return error for null value', () {
      expect(validateNIK(null), equals('NIK wajib diisi'));
    });

    test('should return error for empty string', () {
      expect(validateNIK(''), equals('NIK wajib diisi'));
    });

    test('should return error for invalid format (less than 16 digits)', () {
      expect(validateNIK('12345'), equals('NIK harus 16 digit angka'));
    });

    test('should return error for invalid format (more than 16 digits)', () {
      expect(
        validateNIK('12345678901234567'),
        equals('NIK harus 16 digit angka'),
      );
    });

    test('should return null for valid NIK', () {
      expect(validateNIK('1234567890123456'), isNull);
    });
  });

  group('validatePhone', () {
    test('should return error for null value', () {
      expect(validatePhone(null), equals('No telp wajib diisi'));
    });

    test('should return error for empty string', () {
      expect(validatePhone(''), equals('No telp wajib diisi'));
    });

    test('should return error for invalid format (non-numeric characters)', () {
      expect(
        validatePhone('+62812345a7890'),
        equals('Format nomor telepon tidak valid (Indonesia)'),
      );
    });

    test('should return null for valid phone number', () {
      expect(validatePhone('081234567890'), isNull);
    });
  });

  group('validateJumlah', () {
    test('should return error for null value', () {
      expect(validateJumlah(null), equals('Jumlah wajib diisi'));
    });

    test('should return error for empty string', () {
      expect(validateJumlah(''), equals('Jumlah wajib diisi'));
    });

    test('should return error for non-numeric input', () {
      expect(validateJumlah('abc'), equals('Masukkan angka saja'));
    });

    test('should return error for less than 1,000,000', () {
      expect(validateJumlah('999999'), equals('Jumlah minimal 1.000.000'));
    });

    test(
      'should return null for valid number greater than or equal to 1,000,000',
      () {
        expect(validateJumlah('1000000'), isNull);
      },
    );
  });
}
