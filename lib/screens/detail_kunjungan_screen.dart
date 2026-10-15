import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/kunjungan.dart';
import '../services/lokasi_service.dart';
import 'form_kunjungan_screen.dart';

class DetailKunjunganScreen extends StatelessWidget {
  final Kunjungan kunjungan;
  const DetailKunjunganScreen({super.key, required this.kunjungan});

  Future<void> _edit(BuildContext context) async {
    final pesan = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => FormKunjunganScreen(kunjungan: kunjungan),
      ),
    );
// Kembali ke daftar sambil meneruskan pesan untuk SnackBar
    if (pesan != null && context.mounted) Navigator.pop(context, pesan);
  }

  Future<void> _hapus(BuildContext context) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.delete_outline),
      title: const Text('Hapus kunjungan?'),
      content: Text('Data ${kunjungan.namaPelanggan} akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),

          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin != true) return;
    await DatabaseHelper.instance.hapus(kunjungan.id!);
    if (context.mounted) Navigator.pop(context, 'Kunjungan dihapus');
}

@override
Widget build(BuildContext context) {
  final k = kunjungan;
  final lokasi = k.latitude == null
    ? '-'
    : '${k.latitude}, ${k.longitude}';

  return Scaffold(
    appBar: AppBar(
      title: const Text('Detail Kunjungan'),
      actions: [
        IconButton(
          tooltip: 'Edit',
          icon: const Icon(Icons.edit),
          onPressed: () => _edit(context),
        ),

        IconButton(
          tooltip: 'Hapus',
          icon: const Icon(Icons.delete),
          onPressed: () => _hapus(context),
        ),
      ],
    ),

    body: ListView(
    children: [
      _baris(Icons.person, 'Nama Pelanggan', k.namaPelanggan),
      _baris(Icons.home, 'Alamat', k.alamat),
      _baris(Icons.phone, 'No. HP', k.noHp),
      _baris(Icons.notes, 'Catatan', k.catatan.isEmpty ? '-' : k.catatan),
      _baris(
        Icons.event,
        'Tanggal',
        DateFormat('dd/MM/yyyy HH:mm').format(k.tanggal),
      ),
      _baris(Icons.location_on, 'Lokasi', lokasi),
      if (k.latitude != null) ...[
        FutureBuilder<Position>(
          future: LokasiService.posisiSekarang(),
          builder: (context, posisi) => _baris(
            Icons.straighten,
            'Jarak dari posisi Anda',
            posisi.hasData
                ? LokasiService.formatJarak(
              LokasiService.jarak(
                posisi.data!,
                k.latitude!,
                k.longitude!,
              ),
            )
                : posisi.hasError
                ? '${posisi.error}'
                : 'Menghitung...',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () =>
                LokasiService.navigasi(k.latitude!, k.longitude!),
            icon: const Icon(Icons.directions),
            label: const Text('Navigasi'),
          ),
        ),
      ],
    ],
  ),
);
}
Widget _baris(IconData ikon, String label, String nilai) =>
    ListTile(leading: Icon(ikon), title: Text(label), subtitle: Text(nilai));
}