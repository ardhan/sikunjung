import 'package:shared_preferences/shared_preferences.dart';
// Pengaturan kecil (key-value) yang tetap ada setelah aplikasi ditutup
class PreferensiService {
  static const _kunciNama = 'nama_terakhir';
  static const _kunciTemaGelap = 'tema_gelap';
  static Future<String> ambilNamaTerakhir() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_kunciNama) ?? '';
  }
  static Future<void> simpanNamaTerakhir(String nama) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_kunciNama, nama);
  }
  static Future<bool> ambilTemaGelap() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_kunciTemaGelap) ?? false;
  }
  static Future<void> simpanTemaGelap(bool gelap) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_kunciTemaGelap, gelap);
  }
}