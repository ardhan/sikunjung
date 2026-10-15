import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/preferensi_service.dart';

// Pilihan tema bisa diubah dari halaman mana pun
final temaGelap = ValueNotifier<bool>(false);
Future<void> main() async {
  // Wajib sebelum memakai plugin di dalam main()
  WidgetsFlutterBinding.ensureInitialized();
  temaGelap.value = await PreferensiService.ambilTemaGelap();
  runApp(const SiKunjungApp());
}

class SiKunjungApp extends StatelessWidget {
  const SiKunjungApp({super.key});
  ThemeData _tema(Brightness kecerahan) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.greenAccent,
      brightness: kecerahan,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Dibangun ulang setiap kali nilai temaGelap berubah
    return ValueListenableBuilder<bool>(
      valueListenable: temaGelap,
      builder: (context, gelap, _) => MaterialApp(
        title: 'SiKunjung',
        debugShowCheckedModeBanner: false,
        theme: _tema(Brightness.light),
        darkTheme: _tema(Brightness.dark),
        themeMode: gelap ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
