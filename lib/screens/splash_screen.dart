import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
      _lanjut();
  }

  Future<void> _lanjut() async {
    await Future.delayed(const Duration(seconds: 2));
    final username = await AuthService.sesiAktif();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => username == null
            ? const LoginScreen()
            : DashboardScreen(namaPetugas: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 200, height: 200),
            const SizedBox(height: 5),
            Text(
              'SiKunjung',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: warna.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sistem Informasi Kunjungan Lapangan',
              style: TextStyle(color: warna.primary),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(color: warna.primary),
          ],
        ),
      ),
    );
  }
}