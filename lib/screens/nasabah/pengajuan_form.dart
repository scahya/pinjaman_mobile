import 'package:flutter/material.dart';
import 'package:pinjaman_mobile/providers/auth_provider.dart';
import 'package:pinjaman_mobile/providers/pinjaman_provider.dart';
import 'package:provider/provider.dart';
import '../../api/pinjaman_service.dart';
import '../../utils/validators.dart';

class PengajuanForm extends StatefulWidget {
  const PengajuanForm({super.key});

  @override
  State<PengajuanForm> createState() => _PengajuanFormState();
}

class _PengajuanFormState extends State<PengajuanForm> {
  final _formKey = GlobalKey<FormState>();
  final nikCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final telpCtrl = TextEditingController();
  final jumlahCtrl = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final pinjam = Provider.of<PinjamanProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Ajukan Pinjaman')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nikCtrl,
                decoration: InputDecoration(labelText: 'NIK'),
                validator: validateNIK,
              ),
              TextFormField(
                controller: alamatCtrl,
                decoration: InputDecoration(labelText: 'Alamat'),
                // validator: (v) => v == null || v.isEmpty ? 'Alamat wajib' : '',
              ),
              TextFormField(
                controller: telpCtrl,
                decoration: InputDecoration(labelText: 'No. Telepon'),
                validator: validatePhone,
              ),
              TextFormField(
                controller: jumlahCtrl,
                decoration: InputDecoration(labelText: 'Jumlah (Rp)'),
                keyboardType: TextInputType.number,
                validator: validateJumlah,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Kirim'),
                onPressed: loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => loading = true);
                        try {
                          final res = await pinjam.postAjukanPinjaman(
                            nikCtrl.text.trim(),
                            alamatCtrl.text.trim(),
                            telpCtrl.text.trim(),
                            int.parse(jumlahCtrl.text.replaceAll(',', '')),
                          );
                          // jika sukses redirect ke list
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pengajuan terkirim')),
                          );
                          Navigator.of(context).pop(true);
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                        } finally {
                          setState(() => loading = false);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
