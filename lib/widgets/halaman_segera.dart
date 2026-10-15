import 'package:flutter/material.dart';
// Kerangka halaman yang isinya dibuat di materi berikutnya
class HalamanSegera extends StatelessWidget {
  final String judul;
  final IconData ikon;
  final String keterangan;

  const HalamanSegera({
    super.key,
    required this.judul,
    required this.ikon,
    required this.keterangan,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ikon, size: 72, color: warna.primary),
              const SizedBox(height: 16),
              Text(judul, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(keterangan, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}