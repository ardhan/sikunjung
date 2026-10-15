import 'package:flutter/material.dart';
import 'package:sikunjung/screens/info_perangkat_screen.dart';
import 'beranda_screen.dart';
import 'daftar_kunjungan_screen.dart';
import 'jaringan_screen.dart';
import 'peta_screen.dart';
import 'sensor_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String namaPetugas;
  const DashboardScreen({super.key, required this.namaPetugas});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _indeks = 0;
  void _pilihTab(int i) => setState(() => _indeks = i);

  @override
  Widget build(BuildContext context) {
    final halaman = [
      BerandaScreen(namaPetugas: widget.namaPetugas, onPilihTab: _pilihTab),
      const DaftarKunjunganScreen(),
      const PetaScreen(),
      const SensorScreen(),
      const JaringanScreen(),
      const InfoPerangkatScreen(),
    ];

    return Scaffold(
      body: halaman[_indeks],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: _pilihTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Kunjungan'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Peta'),
          NavigationDestination(icon: Icon(Icons.sensors), label: 'Sensor'),
          NavigationDestination(icon: Icon(Icons.wifi), label: 'Jaringan'),
          NavigationDestination(icon: Icon(Icons.smartphone), label: 'Info'),
        ],
      ),
    );
  }
}