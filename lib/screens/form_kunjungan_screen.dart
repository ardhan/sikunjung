import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/kunjungan.dart';
import '../services/lokasi_service.dart';
class FormKunjunganScreen extends StatefulWidget {
  final Kunjungan? kunjungan;
// null = tambah, terisi = edit
  const FormKunjunganScreen({super.key, this.kunjungan});
  @override
  State<FormKunjunganScreen> createState() => _FormKunjunganScreenState();
}

class _FormKunjunganScreenState extends State<FormKunjunganScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nama = TextEditingController(
    text: widget.kunjungan?.namaPelanggan,
  );
  late final _alamat = TextEditingController(text: widget.kunjungan?.alamat);
  late final _noHp = TextEditingController(text: widget.kunjungan?.noHp);
  late final _catatan = TextEditingController(text: widget.kunjungan?.catatan);
  bool get _modeEdit => widget.kunjungan != null;
  late double? _latitude = widget.kunjungan?.latitude;
  late double? _longitude = widget.kunjungan?.longitude;
  double? _akurasi;
  bool _mencari = false;

  Future<void> _ambilLokasi() async {
    setState(() => _mencari = true);
    try {
      final posisi = await LokasiService.posisiSekarang();
      setState(() {
        _latitude = posisi.latitude;
        _longitude = posisi.longitude;
        _akurasi = posisi.accuracy;
      });
    } on String catch (pesan) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(pesan)));
    } finally {
      if (mounted) setState(() => _mencari = false);
    }
  }

  @override
  void dispose() {
    for (final c in [_nama, _alamat, _noHp, _catatan]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _wajib(String? nilai, String label) =>
      (nilai == null || nilai.trim().isEmpty) ? '$label wajib diisi' : null;
  String? _cekNoHp(String? nilai) {
    final hp = nilai?.trim() ?? '';
    if (hp.isEmpty) return 'No. HP wajib diisi';
    if (!RegExp(r'^08[0-9]{8,11}$').hasMatch(hp)) {
      return 'Diawali 08, berisi 10-13 angka';
    }
    return null;
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final lama = widget.kunjungan;
    final data = Kunjungan(
      id: lama?.id,
      namaPelanggan: _nama.text.trim(),
      alamat: _alamat.text.trim(),
      noHp: _noHp.text.trim(),
      catatan: _catatan.text.trim(),
      latitude: _latitude ?? lama?.latitude,
      longitude: _longitude ?? lama?.longitude,
      tanggal: lama?.tanggal ?? DateTime.now(),
    );

    if (_modeEdit) {
      await DatabaseHelper.instance.ubah(data);
    } else {
      await DatabaseHelper.instance.tambah(data);
    }

    if (!mounted) return;

    Navigator.pop(
      context,
      _modeEdit ? 'Kunjungan diperbarui' : 'Kunjungan disimpan',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modeEdit ? 'Edit Kunjungan' : 'Tambah Kunjungan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(key: _formKey, child: _isiForm()),
          ),
        ),
      ),
    );
  }

  Widget _isiForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nama,
          decoration: const InputDecoration(
            labelText: 'Nama Pelanggan',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (v) => _wajib(v, 'Nama pelanggan'),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _alamat,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Alamat',
            prefixIcon: Icon(Icons.home),
          ),
          validator: (v) => _wajib(v, 'Alamat'),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _noHp,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'No. HP',
            prefixIcon: Icon(Icons.phone),
          ),
          validator: _cekNoHp,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _catatan,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Catatan (opsional)',
            prefixIcon: Icon(Icons.notes),
          ),
        ),

        const SizedBox(height: 24),

        Card(
          child: ListTile(
            leading: const Icon(Icons.my_location),
            title: Text(
              _latitude == null
                  ? 'Lokasi belum diambil'
                  : '${_latitude!.toStringAsFixed(6)}, '
                  '${_longitude!.toStringAsFixed(6)}',
            ),
            subtitle: _akurasi == null
                ? null
                : Text('Akurasi ± ${_akurasi!.toStringAsFixed(0)} m'),
            trailing: _mencari
                ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(),
            )
                : TextButton(
              onPressed: _ambilLokasi,
              child: const Text('Ambil Lokasi'),
            ),
          ),
        ),
        const SizedBox(height: 24),

        FilledButton.icon(
          onPressed: _simpan,
          icon: const Icon(Icons.save),
          label: const Text('Simpan'),
        ),
      ],
    );
  }
}