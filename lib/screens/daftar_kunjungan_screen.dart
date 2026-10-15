import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/kunjungan.dart';
import 'detail_kunjungan_screen.dart';
import 'form_kunjungan_screen.dart';
class DaftarKunjunganScreen extends StatefulWidget {
  const DaftarKunjunganScreen({super.key});
  @override
  State<DaftarKunjunganScreen> createState() => _DaftarKunjunganScreenState();
}

class _DaftarKunjunganScreenState extends State<DaftarKunjunganScreen> {
  List<Kunjungan> _semua = [];
  String _kata = '';

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    final data = await DatabaseHelper.instance.ambilSemua();
    if (mounted) setState(() => _semua = data);
  }

  Future<void> _buka(Widget halaman) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final pesan = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => halaman),
    );
    _muat();

    if (pesan != null && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(pesan)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final kata = _kata.toLowerCase();
    final hasil = _semua.where(
          (k) =>
          k.namaPelanggan.toLowerCase().contains(kata) ||
              k.alamat.toLowerCase().contains(kata),
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kunjungan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              hintText: 'Cari nama atau alamat',
              leading: const Icon(Icons.search),
              onChanged: (teks) => setState(() => _kata = teks),
            ),
          ),
          Expanded(child: _daftar(hasil)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _buka(const FormKunjunganScreen()),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _daftar(List<Kunjungan> hasil) {
    if (hasil.isEmpty) {
      return Center(
        child: Text(
          _kata.isEmpty ? 'Belum ada data kunjungan' : 'Tidak ditemukan',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: hasil.length,
      itemBuilder: (context, i) {
        final k = hasil[i];
        return ListTile(
          leading: CircleAvatar(child: Text(k.namaPelanggan[0])),
          title: Text(k.namaPelanggan),
          subtitle: Text(
            '${k.alamat}\n'
              '${DateFormat('dd/MM/yyyy HH:mm').format(k.tanggal)}',
          ),
          isThreeLine: true,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _buka(DetailKunjunganScreen(kunjungan: k)),
        );
      },
    );
  }
}