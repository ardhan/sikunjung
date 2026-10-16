import 'package:connectivity_plus/connectivity_plus.dart';
class JaringanService {
  static final _konektivitas = Connectivity();
  static Future<List<ConnectivityResult>> cek() =>
      _konektivitas.checkConnectivity();// Memberi nilai baru setiap kali jenis koneksi berubah
  static Stream<List<ConnectivityResult>> get perubahan =>
      _konektivitas.onConnectivityChanged;// Daftar kosong = belum selesai dicek, dianggap online
  static bool online(List<ConnectivityResult> hasil) =>
      hasil.isEmpty || hasil.any((h) => h != ConnectivityResult.none);
  static String nama(List<ConnectivityResult> hasil) {
    if (hasil.isEmpty) return 'Memeriksa...';
    if (hasil.contains(ConnectivityResult.wifi)) return 'WiFi';
    if (hasil.contains(ConnectivityResult.mobile)) return 'Data seluler';
    if (hasil.contains(ConnectivityResult.ethernet)) return 'Ethernet';
    if (online(hasil)) return 'Terhubung';
    return 'Tidak ada koneksi';
  }
}