import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

// Memanggil onGoyang bila HP diguncang cukup keras
class DeteksiGoyang {
  static const ambang = 25.0;
  // m/s²; saat diam hanya ≈ 9,8 (gravitasi)
  final void Function() onGoyang;
  StreamSubscription<AccelerometerEvent>? _langganan;
  DateTime _terakhir = DateTime(0);
  DeteksiGoyang(this.onGoyang);
  void mulai() {
    // Tanpa accelerometer: onError kosong membuat fitur ini diam saja
    _langganan = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_cek, onError: (_) {});
  }

  void _cek(AccelerometerEvent e) {
    final besar = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    final sekarang = DateTime.now();
    // Jeda 1 detik agar satu guncangan tidak terhitung berkali-kali
    if (besar > ambang && sekarang.difference(_terakhir).inSeconds >= 1) {
      _terakhir = sekarang;
      onGoyang();
    }
  }

  void berhenti() => _langganan?.cancel();
}
