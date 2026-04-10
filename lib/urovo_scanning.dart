
import 'urovo_scanning_platform_interface.dart';

class UrovoScanning {
  Future<String?> getPlatformVersion() {
    return UrovoScanningPlatform.instance.getPlatformVersion();
  }
}
