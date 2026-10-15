import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/kunjungan.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final instance = DatabaseHelper._();
  Database? _db;
  // Database dibuka sekali, lalu dipakai ulang
  Future<Database> get database async => _db ??= await _buka();
  Future<Database> _buka() async {
    final lokasi = join(await getDatabasesPath(), 'sikunjung.db');
    return openDatabase(lokasi, version: 1, onCreate: _buatTabel);
  }

  Future<void> _buatTabel(Database db, int versi) async {
    await db.execute('''
CREATE TABLE kunjungan (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nama_pelanggan TEXT NOT NULL,
alamat TEXT NOT NULL,
no_hp TEXT NOT NULL,
catatan TEXT,
latitude REAL,
longitude REAL,
tanggal TEXT NOT NULL
)
''');
    await db.execute('''
CREATE TABLE users (
id INTEGER PRIMARY KEY AUTOINCREMENT,
username TEXT NOT NULL UNIQUE,
password_hash TEXT NOT NULL
)
''');
  }

  Future<List<Kunjungan>> ambilSemua() async {
    final db = await database;
    final hasil = await db.query('kunjungan', orderBy: 'tanggal DESC');
    return hasil.map(Kunjungan.fromMap).toList();
  }

  Future<int> tambah(Kunjungan k) async {
    final db = await database;
    // id dikosongkan agar dibuat otomatis oleh AUTOINCREMENT
    return db.insert('kunjungan', k.toMap()..remove('id'));
  }

  Future<int> ubah(Kunjungan k) async {
    final db = await database;
    return db.update(
      'kunjungan',
      k.toMap(),
      where: 'id = ?',
      whereArgs: [k.id],
    );
  }

  Future<int> hapus(int id) async {
    final db = await database;
    return db.delete('kunjungan', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, Object?>?> cariUser(String username) async {
    final db = await database;
    final hasil = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return hasil.isEmpty ? null : hasil.first;
  }
  
  Future<int> tambahUser(String username, String passwordHash) async {
    final db = await database;
    return db.insert('users', {
      'username': username,
      'password_hash': passwordHash,
    });
  }
}
