/*import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'urovo_scanning_method_channel.dart';

abstract class UrovoScanningPlatform extends PlatformInterface {
  /// Constructs a UrovoScanningPlatform.
  UrovoScanningPlatform() : super(token: _token);

  static final Object _token = Object();

  static UrovoScanningPlatform _instance = MethodChannelUrovoScanning();

  /// The default instance of [UrovoScanningPlatform] to use.
  ///
  /// Defaults to [MethodChannelUrovoScanning].
  static UrovoScanningPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UrovoScanningPlatform] when
  /// they register themselves.
  static set instance(UrovoScanningPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}*/
