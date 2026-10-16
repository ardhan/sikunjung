import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});
  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  static const _interval = SensorInterval.uiInterval;
  final _langganan = <StreamSubscription>[];
  final _tidakAda = <String>{};
  List<double>? _akselerometer, _giroskop, _magnetometer;
  @override
  void dispose() {
    // Wajib: hentikan sensor saat halaman ditutup agar hemat baterai
    for (final l in _langganan) {
      l.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dengar(
      'Accelerometer',
      accelerometerEventStream(samplingPeriod: _interval),
      (e) => _akselerometer = [e.x, e.y, e.z],
    );
    _dengar(
      'Gyroscope',
      gyroscopeEventStream(samplingPeriod: _interval),
      (e) => _giroskop = [e.x, e.y, e.z],
    );
    _dengar(
      'Magnetometer',
      magnetometerEventStream(samplingPeriod: _interval),
      (e) => _magnetometer = [e.x, e.y, e.z],
    );
  }

  void _dengar<T>(String nama, Stream<T> aliran, void Function(T) simpan) {
    _langganan.add(
      aliran.listen(
        (e) => setState(() => simpan(e)),
        // Perangkat tanpa sensor ini mengirim error
        onError: (_) => setState(() => _tidakAda.add(nama)),
        cancelOnError: true,
      ),
    );
  }

  double get _derajat {
    final m = _magnetometer!;
    return (atan2(-m[0], m[1]) * 180 / pi + 360) % 360;
  }

  static const _mataAngin = [
    'Utara',
    'Timur Laut',
    'Timur',
    'Tenggara',
    'Selatan',
    'Barat Daya',
    'Barat',
    'Barat Laut',
  ];
  String get _arah => _mataAngin[((_derajat + 22.5) ~/ 45) % 8];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Perangkat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kartu('Accelerometer', 'm/s²', Icons.open_with, _akselerometer),
          _kartu('Gyroscope', 'rad/s', Icons.threesixty, _giroskop),
          _kartu('Magnetometer', 'μT', Icons.explore, _magnetometer),
          _kompas(),
        ],
      ),
    );
  }

  Widget _kartu(String nama, String satuan, IconData ikon, List<double>? n) {
    final teks = _tidakAda.contains(nama)
        ? 'Sensor tidak tersedia di perangkat ini'
        : n == null
        ? 'Menunggu data...'
        : 'X: ${n[0].toStringAsFixed(2)} '
              'Y: ${n[1].toStringAsFixed(2)} '
              'Z: ${n[2].toStringAsFixed(2)}';
    return Card(
      child: ListTile(
        leading: Icon(ikon, size: 36),
        title: Text('$nama ($satuan)'),
        subtitle: Text(teks),
      ),
    );
  }

  Widget _kompas() {
    if (_magnetometer == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Transform.rotate(
              // Jarum diputar berlawanan agar selalu menunjuk utara
              angle: -_derajat * pi / 180,
              child: const Icon(Icons.navigation, size: 96),
            ),
            Text(
              '${_derajat.toStringAsFixed(0)}° $_arah',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
