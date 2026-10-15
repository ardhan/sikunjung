
import 'package:permission_handler/permission_handler.dart';
// Izin diminta saat fitur dipakai, bukan semuanya di awal
class IzinService {
  static Future<bool> mintaLokasi() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return status.isGranted;
  }
}