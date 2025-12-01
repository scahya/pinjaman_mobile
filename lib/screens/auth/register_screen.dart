import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final namaLengkapCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: usernameCtrl,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: namaLengkapCtrl,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: confirmCtrl,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password",
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Wajib diisi";
                  if (v != passwordCtrl.text) return "Password tidak cocok";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: auth.loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        final ok = await auth.register(
                          usernameCtrl.text.trim(),
                          passwordCtrl.text.trim(),
                          namaLengkapCtrl.text.trim(),
                        );

                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Registrasi berhasil, silakan login.",
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                child: auth.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
