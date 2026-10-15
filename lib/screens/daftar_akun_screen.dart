import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class DaftarAkunScreen extends StatefulWidget {
  const DaftarAkunScreen({super.key});
  @override
  State<DaftarAkunScreen> createState() => _DaftarAkunScreenState();
}

class _DaftarAkunScreenState extends State<DaftarAkunScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _ulangi = TextEditingController();
  @override
  void dispose() {
    for (final c in [_username, _password, _ulangi]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _cekUsername(String? v) {
    if (v == null || !RegExp(r'^[a-z0-9_]{4,20}$').hasMatch(v)) {
      return 'Huruf kecil, angka, atau _ (4-20 karakter)';
    }
    return null;
  } // Password kuat: minimal 8 karakter, ada huruf dan angka

  String? _cekPassword(String? v) {
    if (v == null || v.length < 8) return 'Minimal 8 karakter';
    if (!RegExp(r'[A-Za-z]').hasMatch(v) || !RegExp(r'\d').hasMatch(v)) {
      return 'Harus berisi huruf dan angka';
    }
    return null;
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final berhasil = await AuthService.daftar(_username.text, _password.text);
    if (!mounted) return;
    if (!berhasil) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Username sudah dipakai')));
      return;
    }
    Navigator.pop(context, 'Akun dibuat, silakan masuk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Petugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(key: _formKey, child: _isiForm()),
          ),
        ),
      ),
    );
  }

  Widget _isiForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _username,
          decoration: const InputDecoration(labelText: 'Username'),
          validator: _cekUsername,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _password,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
          validator: _cekPassword,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ulangi,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Ulangi Password'),
          validator: (v) => v == _password.text ? null : 'Password tidak sama',
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _simpan, child: const Text('Buat Akun')),
      ],
    );
  }
}
