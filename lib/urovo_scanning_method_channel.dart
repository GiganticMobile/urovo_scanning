import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'urovo_scanning_platform_interface.dart';

/// An implementation of [UrovoScanningPlatform] that uses method channels.
class MethodChannelUrovoScanning extends UrovoScanningPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('urovo_scanning');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
