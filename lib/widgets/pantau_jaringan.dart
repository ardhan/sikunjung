import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../services/jaringan_service.dart';

// Membangun ulang isinya setiap kali koneksi berubah
class PantauJaringan extends StatefulWidget {
  final Widget Function(BuildContext, List<ConnectivityResult>) builder;
  const PantauJaringan({super.key, required this.builder});
  @override
  State<PantauJaringan> createState() => _PantauJaringanState();
}

class _PantauJaringanState extends State<PantauJaringan> {
  List<ConnectivityResult> _hasil = [];
  late final StreamSubscription _langganan;
  @override
  void initState() {
    super.initState();
    JaringanService.cek().then(_perbarui);
    _langganan = JaringanService.perubahan.listen(_perbarui);
  }

  void _perbarui(List<ConnectivityResult> hasil) {
    if (mounted) setState(() => _hasil = hasil);
  }

  @override
  void dispose() {
    _langganan.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _hasil);
}
