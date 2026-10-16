import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../services/jaringan_service.dart';
import '../widgets/pantau_jaringan.dart';

class JaringanScreen extends StatelessWidget {
  const JaringanScreen({super.key});
  IconData _ikon(List<ConnectivityResult> hasil) {
    if (hasil.contains(ConnectivityResult.wifi)) return Icons.wifi;
    if (hasil.contains(ConnectivityResult.mobile)) {
      return Icons.signal_cellular_alt;
    }
    return JaringanService.online(hasil) ? Icons.lan : Icons.wifi_off;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Jaringan')),
      body: PantauJaringan(builder: _isi),
    );
  }

  Widget _isi(BuildContext context, List<ConnectivityResult> hasil) {
    final teks = Theme.of(context).textTheme;
    final warna = Theme.of(context).colorScheme;
    final online = JaringanService.online(hasil);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Icon(
          _ikon(hasil),
          size: 96,
          color: online ? warna.primary : warna.error,
        ),
        Text(
          JaringanService.nama(hasil),
          textAlign: TextAlign.center,
          style: teks.headlineSmall,
        ),
        const SizedBox(height: 24),
        Text('Fitur aplikasi', style: teks.titleMedium),
        _fitur(Icons.edit_note, 'Catat kunjungan', true),
        _fitur(Icons.my_location, 'Ambil lokasi GPS', true),
        _fitur(Icons.map, 'Peta OpenStreetMap', online),
        _fitur(Icons.directions, 'Navigasi Google Maps', online),
      ],
    );
  }

  Widget _fitur(IconData ikon, String nama, bool bisa) => ListTile(
    leading: Icon(ikon),
    title: Text(nama),
    trailing: Text(bisa ? 'Bisa' : 'Butuh internet'),
  );
}
