import 'package:flutter/material.dart';

import '../models/info_perangkat.dart';
import '../services/device_info_service.dart';

class InfoPerangkatScreen extends StatefulWidget {
  const InfoPerangkatScreen({super.key});
  @override
  State<InfoPerangkatScreen> createState() => _InfoPerangkatScreenState();
}

class _InfoPerangkatScreenState extends State<InfoPerangkatScreen> {
  // Dibuat sekali saja, tidak diulang setiap layar di-render ulang
  late final Future<InfoPerangkat> _info = DeviceInfoService().ambilInfo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info Perangkat')),
      body: FutureBuilder<InfoPerangkat>(
        future: _info,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal membaca: ${snapshot.error}'));
          }
          return _daftarInfo(snapshot.data!);
        },
      ),
    );
  }

  Widget _daftarInfo(InfoPerangkat info) => ListView(
    children: [
      _baris(Icons.phone_android, 'Sistem Operasi', info.sistemOperasi),
      _baris(Icons.numbers, 'Versi OS / API Level', info.versiOs),
      _baris(Icons.business, 'Merek', info.merek),
      _baris(Icons.smartphone, 'Model', info.model),
      _baris(Icons.apps, 'Nama Aplikasi', info.namaAplikasi),
      _baris(Icons.info_outline, 'Versi Aplikasi', info.versiAplikasi),
    ],
  );
  Widget _baris(IconData ikon, String label, String nilai) =>
      ListTile(leading: Icon(ikon), title: Text(label), subtitle: Text(nilai));
}
