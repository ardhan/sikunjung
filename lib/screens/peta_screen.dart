// lib/screens/peta_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../database/database_helper.dart';
import '../models/kunjungan.dart';
import '../services/lokasi_service.dart';

class PetaScreen extends StatefulWidget {
  const PetaScreen({super.key});
  @override
  State<PetaScreen> createState() => _PetaScreenState();
}

class _PetaScreenState extends State<PetaScreen> {
  List<Kunjungan> _data = [];
  Position? _posisi;
  bool _siap = false;
  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    final semua = await DatabaseHelper.instance.ambilSemua();
    Position? posisi;
    try {
      posisi = await LokasiService.posisiSekarang();
    } on String catch (pesan) {
      // Peta tetap tampil walau posisi petugas tidak didapat
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(pesan)));
      }
    }
    if (!mounted) return;
    setState(() {
      _data = semua.where((k) => k.latitude != null).toList();
      _posisi = posisi;
      _siap = true;
    });
  } // Titik tengah: posisi petugas, kunjungan pertama, atau Jakarta

  LatLng get _pusat => _posisi != null
      ? LatLng(_posisi!.latitude, _posisi!.longitude)
      : _data.isNotEmpty
      ? LatLng(_data.first.latitude!, _data.first.longitude!)
      : const LatLng(-6.2, 106.8167);
  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Peta Kunjungan')),
      body: !_siap
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(initialCenter: _pusat, initialZoom: 14),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.sikunjung',
                ),
                MarkerLayer(
                  markers: [
                    for (final k in _data) _marker(k, warna.error),
                    if (_posisi != null)
                      Marker(
                        point: _pusat,
                        child: Icon(Icons.my_location, color: warna.primary),
                      ),
                  ],
                ),
                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                ),
              ],
            ),
    );
  }

  Marker _marker(Kunjungan k, Color warna) => Marker(
    point: LatLng(k.latitude!, k.longitude!),
    width: 44,
    height: 44,
    child: GestureDetector(
      onTap: () => _info(k),
      child: Icon(Icons.location_on, size: 44, color: warna),
    ),
  );
  void _info(Kunjungan k) {
    final jarak = _posisi == null
        ? '-'
        : LokasiService.formatJarak(
            LokasiService.jarak(_posisi!, k.latitude!, k.longitude!),
          );
    showModalBottomSheet(
      context: context,
      builder: (_) => ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(k.namaPelanggan),
        subtitle: Text('${k.alamat}\nJarak: $jarak'),
        trailing: IconButton.filled(
          tooltip: 'Navigasi',
          icon: const Icon(Icons.directions),
          onPressed: () => LokasiService.navigasi(k.latitude!, k.longitude!),
        ),
      ),
    );
  }
}
