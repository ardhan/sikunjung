import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/database_helper.dart';

class AuthService {
  static const _penyimpanan = FlutterSecureStorage();
  static const _kunciSesi = 'sesi_username';

  static String hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  static Future<bool> daftar(String username, String password) async {
    final db = DatabaseHelper.instance;
    if (await db.cariUser(username) != null) return false;
    await db.tambahUser(username, hash(password));
    return true;
  }

  static Future<bool> masuk(String username, String password) async {
    final user = await DatabaseHelper.instance.cariUser(username);
    if (user == null || user['password_hash'] != hash(password)) {
      return false;
    }
    await _penyimpanan.write(key: _kunciSesi, value: username);
    return true;
  }

  // Username bila sesi masih tersimpan, null bila belum login
  static Future<String?> sesiAktif() => _penyimpanan.read(key: _kunciSesi);
  static Future<void> keluar() => _penyimpanan.delete(key: _kunciSesi);
}
