import '../models/kunjungan.dart';
// Sementara data disimpan di memori (List) dan hilang saat aplikasi ditutup.
// Di Materi 3 isi kelas ini diganti SQLite; layar tidak perlu diubah.
class DatabaseHelperLama {
  DatabaseHelperLama._();
  static final instance = DatabaseHelperLama._();
  int _idBerikutnya = 4;
  final List<Kunjungan> _data = [
    Kunjungan(
      id: 1,
      namaPelanggan: 'Andi Saputra',
      alamat: 'Jl. Merdeka No. 1, Jakarta',
      noHp: '081234567890',
      catatan: 'Minta dihubungi sore',
      tanggal: DateTime(2026, 10, 12, 9, 30),
    ),

    Kunjungan(
      id: 2,
      namaPelanggan: 'Sari Wulandari',
      alamat: 'Jl. Sudirman No. 45, Jakarta',
      noHp: '085712345678',
      tanggal: DateTime(2026, 10, 13, 14, 0),
    ),

    Kunjungan(
      id: 3,
      namaPelanggan: 'Joko Prasetyo',
      alamat: 'Jl. Gatot Subroto No. 8, Bekasi',
      noHp: '081398765432',
      tanggal: DateTime(2026, 10, 14, 8, 15),
    ),
  ];

  Future<List<Kunjungan>> ambilSemua() async {
    return [..._data]..sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  Future<void> tambah(Kunjungan k) async {
    _data.add(
      Kunjungan(
        id: _idBerikutnya++,
        namaPelanggan: k.namaPelanggan,
        alamat: k.alamat,
        noHp: k.noHp,
        catatan: k.catatan,
        latitude: k.latitude,
        longitude: k.longitude,
        tanggal: k.tanggal,
      ),
    );
  }

  Future<void> ubah(Kunjungan k) async {
    final i = _data.indexWhere((d) => d.id == k.id);
    _data[i] = k;
  }

  Future<void> hapus(int id) async {
    _data.removeWhere((d) => d.id == id);
  }
}