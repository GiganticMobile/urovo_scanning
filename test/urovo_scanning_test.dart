/*import 'package:flutter_test/flutter_test.dart';
import 'package:urovo_scanning/urovo_scanning.dart';
import 'package:urovo_scanning/urovo_scanning_platform_interface.dart';
import 'package:urovo_scanning/urovo_scanning_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUrovoScanningPlatform
    with MockPlatformInterfaceMixin
    implements UrovoScanningPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UrovoScanningPlatform initialPlatform = UrovoScanningPlatform.instance;

  test('$MethodChannelUrovoScanning is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUrovoScanning>());
  });

  test('getPlatformVersion', () async {
    UrovoScanning urovoScanningPlugin = UrovoScanning();
    MockUrovoScanningPlatform fakePlatform = MockUrovoScanningPlatform();
    UrovoScanningPlatform.instance = fakePlatform;

    expect(await urovoScanningPlugin.getPlatformVersion(), '42');
  });
}*/
