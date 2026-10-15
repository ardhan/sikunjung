import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/auth_service.dart';
import '../widgets/kartu_menu.dart';
import '../services/preferensi_service.dart';
import '../main.dart';
import 'form_kunjungan_screen.dart';
// import 'info_perangkat_screen.dart';
import 'info_perangkat_screen.dart';
import 'login_screen.dart';
class BerandaScreen extends StatefulWidget {
  final String namaPetugas;
  final ValueChanged<int> onPilihTab;
  const BerandaScreen({
    super.key,
    required this.namaPetugas,
    required this.onPilihTab,
  });
  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _jumlah = 0;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    final data = await DatabaseHelper.instance.ambilSemua();
    if (mounted) setState(() => _jumlah = data.length);
  }

  Future<void> _buka(Widget halaman) async {
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

  Future<void> _keluar() async {
    await AuthService.keluar();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: _keluar,
          ),
        ],
      ),*/

      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            tooltip: 'Ganti tema',
            icon: Icon(temaGelap.value ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              temaGelap.value = !temaGelap.value;
              PreferensiService.simpanTemaGelap(temaGelap.value);
            },
          ),
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: _keluar,
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Halo, ${widget.namaPetugas}',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),
          _kartuRingkasan(context),
          const SizedBox(height: 24),
          Text('Menu Utama', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _menuUtama(),
        ],
      ),
    );
  }

  Widget _kartuRingkasan(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Card(
      color: warna.primaryContainer,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(Icons.assignment, size: 40, color: warna.primary),
        title: Text(
          '$_jumlah',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: const Text('Total kunjungan tercatat'),
      ),
    );
  }

  Widget _menuUtama() {
    final menu = [
      KartuMenu(
        ikon: Icons.add_location_alt,
        label: 'Tambah Kunjungan',
        onTap: () => _buka(const FormKunjunganScreen()),
      ),

      KartuMenu(
        ikon: Icons.list_alt,
        label: 'Daftar Kunjungan',
        onTap: () => widget.onPilihTab(1),
      ),

      KartuMenu(
        ikon: Icons.map,
        label: 'Peta',
        onTap: () => widget.onPilihTab(2),
      ),

      KartuMenu(
        ikon: Icons.sensors,
        label: 'Sensor',
        onTap: () => widget.onPilihTab(3),
      ),

      KartuMenu(
        ikon: Icons.wifi,
        label: 'Jaringan',
        onTap: () => widget.onPilihTab(4),
        ),

      KartuMenu(
        ikon: Icons.phone_android,
        label: 'Info Perangkat',
        onTap: () => _buka(const InfoPerangkatScreen()),
      ),
    ];// Jumlah kolom mengikuti lebar layar: HP kecil 2, HP 3, tablet s.d. 6
    return LayoutBuilder(
      builder: (context, ukuran) => GridView.count(
        crossAxisCount: (ukuran.maxWidth ~/ 120).clamp(2, 6),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: menu,
      ),
    );
  }
}