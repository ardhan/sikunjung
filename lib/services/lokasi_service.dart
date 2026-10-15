// lib/services/lokasi_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'izin_service.dart';

class LokasiService {
  static const _gpsMati = 'GPS tidak aktif. Nyalakan lokasi di perangkat.';
  // Melempar pesan (String) bila GPS mati atau izin ditolak
  static Future<Position> posisiSekarang() async {
    if (!await Geolocator.isLocationServiceEnabled()) throw _gpsMati;
    if (!await IzinService.mintaLokasi()) throw 'Izin lokasi ditolak.';
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } on LocationServiceDisabledException {
      // Dialog "Location Accuracy" dari Google ditolak pengguna
      throw _gpsMati;
    }
  }

  // Jarak garis lurus dalam meter
  static double jarak(Position dari, double lat, double lng) =>
      Geolocator.distanceBetween(dari.latitude, dari.longitude, lat, lng);
  static String formatJarak(double meter) => meter < 1000
      ? '${meter.toStringAsFixed(0)} m'
      : '${(meter / 1000).toStringAsFixed(1)} km';
  // Membuka rute di aplikasi Google Maps
  static Future<bool> navigasi(double lat, double lng) => launchUrl(
    Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'),
    mode: LaunchMode.externalApplication,
  );
}
