import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/info_perangkat.dart';

class DeviceInfoService {
  final _deviceInfo = DeviceInfoPlugin();
  Future<InfoPerangkat> ambilInfo() async {
    final app = await PackageInfo.fromPlatform();
    final versiApp = '${app.version}+${app.buildNumber}';
    if (Platform.isAndroid) {
      final android = await _deviceInfo.androidInfo;
      final versi = android.version;
      return InfoPerangkat(
        sistemOperasi: 'Android',
        versiOs: 'Android ${versi.release} (API ${versi.sdkInt})',
        merek: android.brand,
        model: android.model,
        namaAplikasi: app.appName,
        versiAplikasi: versiApp,
      );
    }
    if (Platform.isIOS) {
      final ios = await _deviceInfo.iosInfo;
      return InfoPerangkat(
        sistemOperasi: ios.systemName,
        versiOs: ios.systemVersion,
        merek: 'Apple',
        model: ios.model,
        namaAplikasi: app.appName,
        versiAplikasi: versiApp,
      );
    }
    throw UnsupportedError('Platform tidak didukung');
  }
}
