// lib/screens/login_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'daftar_akun_screen.dart';
import 'dashboard_screen.dart';
import '../services/preferensi_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _sembunyikan = true;

  @override
  void initState() {
    super.initState();
    PreferensiService.ambilNamaTerakhir().then((nama) {
      if (mounted) _username.text = nama;
    });
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    if (!_formKey.currentState!.validate()) return;
    final nama = _username.text.trim();
    final berhasil = await AuthService.masuk(nama, _password.text);
    if (!mounted) return;
    if (!berhasil) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Username atau password salah')),
        );
      return;
    }

    await PreferensiService.simpanNamaTerakhir(nama);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DashboardScreen(namaPetugas: nama)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(key: _formKey, child: _isiForm(context)),
          ),
        ),
      ),
    );
  }

  Future<void> _daftar() async {
    final pesan = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const DaftarAkunScreen()),
    );
    if (pesan != null && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  Widget _isiForm(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/images/logo.png', width: 100, height: 100),
        Text(
          'Masuk SiKunjung',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        Text(
          'Masuklah menggunakan username dan password anda',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),

        const SizedBox(height: 24),

        TextFormField(
          controller: _username,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Username wajib diisi' : null,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _password,
          obscureText: _sembunyikan,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _sembunyikan ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => setState(() => _sembunyikan = !_sembunyikan),
            ),
          ),
          validator: (v) => (v == null || v.length < 6)
              ? 'Password minimal 6 karakter'
              : null,
        ),
        const SizedBox(height: 24),

        FilledButton.icon(
          onPressed: _masuk,
          icon: const Icon(Icons.login),
          label: const Text('Masuk'),
        ),

        const SizedBox(height: 8),
        TextButton(
          onPressed: _daftar,
          child: const Text('Belum punya akun? Daftar'),
        ),
      ],
    );
  }
}
