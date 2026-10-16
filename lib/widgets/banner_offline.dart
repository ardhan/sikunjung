import 'package:flutter/material.dart';
class BannerOffline extends StatelessWidget {
  const BannerOffline({super.key});
  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Material(
      color: warna.errorContainer,
      child: ListTile(
        leading: Icon(Icons.cloud_off, color: warna.onErrorContainer),
        title: const Text('Offline'),
        subtitle: const Text('Kunjungan tetap bisa dicatat di perangkat'),
      ),
    );
  }
}