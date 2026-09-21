import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:urovo_scanning/Code.dart' as c;
import 'package:urovo_scanning/light_mode.dart';
import 'package:urovo_scanning/scan_mode.dart';
import 'package:urovo_scanning/sound.dart';
import 'package:urovo_scanning/src/property_id.dart';
import 'package:urovo_scanning/src/scanner_handler.dart';
import 'package:urovo_scanning/src/urovo_message_interface.g.dart';

@GenerateNiceMocks([MockSpec<UrovoMessageInterface>()])
import 'scanner_handler_tests.mocks.dart';

//build mocks
//flutter pub run build_runner build --delete-conflicting-outputs

void main() {

  group('is device compatible tests', () {

    test('device is compatible test', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getDeviceManufacture()).thenAnswer((_) async {
        return 'Urovo';
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final isCompatible = await scannerHandler.isDeviceCompatible();

      expect(isCompatible, true,
          reason: 'unexpected is device compatible value');
    });

    test('device is compatible wrong platform test', () async {

      //urovo scanner currently use android operating systems
      //so if the platform is anything other than android then
      //it should not be compatible
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getDeviceManufacture()).thenAnswer((_) async {
        return 'Urovo';
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final isCompatible = await scannerHandler.isDeviceCompatible();

      expect(isCompatible, false,
          reason: 'unexpected is device compatible value');
    });

    test('device is compatible wrong manufacture test', () async {

      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      //since this plugin is made for urovo scanner if the manufacture
      //is anything other than urovo then the device will not be compatible
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getDeviceManufacture()).thenAnswer((_) async {
        return 'Test';
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final isCompatible = await scannerHandler.isDeviceCompatible();

      expect(isCompatible, false,
          reason: 'unexpected is device compatible value');
    });
  });

  group('barcode string stream tests', () {
    //there it no logic in the barcode string stream function as the logic is
    //handled by the native side
  });

  group('barcode bytes stream tests', () {
    //there it no logic in the barcode bytes stream function as the logic is
    //handled by the native side
  });

  group('barcode stream tests', () {
    //there it no logic in the barcode stream function as the logic is
    //handled by the native side
  });

  group('barcode image stream', () {
    //there it no logic in the barcode image stream function as the logic is
    //handled by the native side
  });

  group('start scanning tests', () {

    //there it no logic in the start scanning function as the logic is
    //handled by the native side

  });

  group('stop scanning tests', () {
    //there it no logic in the stop scanning function as the logic is
    //handled by the native side
  });

  group('close scanner tests', () {
    //there it no logic in the close scanner function as the logic is
    //handled by the native side
  });

  group('get time out tests', () {

    test('get time out test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.laserOnTime.id,
            reason: 'unexpected property id');

        /*
        the time out is returned in 10ths of a second i.e. 100ms
         */
        return 50;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final timeOut = await scannerHandler.getTimeout();
      expect(timeOut, 5.0, reason: 'unable to get time out');
    });

    test('get time out with error', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((_) async {
        /*
          the app cannot find parameter value. Either the property id does
          not exist or the device does not have a scanner.
           */
        throw Exception('error');
      });

      var error = 'no error';
      try {
        final scannerHandler = ScannerHandler(messageHandler: messageHandler);
        await scannerHandler.getTimeout();
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to get time out. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error value');
    });

  });

  group('set time out test', () {

    test('set time out test', () async {

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final timeout = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.laserOnTime.id, reason: 'unexpected property id');
        expect(timeout, 50, reason: 'unexpected time out value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setTimeout(5);

    });

    test('set timeout with error', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        /*
          the app cannot set parameter value. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      var error = 'no error';
      try {
        final scannerHandler = ScannerHandler(messageHandler: messageHandler);
        await scannerHandler.setTimeout(5);
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to set time out. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error value');
    });

  });

  group('get sound mode tests', () {

    test('get no sound mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.sendGoodReadBeepEnable.id,
            reason: 'unexpected property id');
        return 0;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getSoundMode();
      expect(mode, Sound.none, reason: 'unexpected sound mode');
    });

    test('get short sound mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((_) async {
        return 1;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getSoundMode();
      expect(mode, Sound.short, reason: 'unexpected sound mode');
    });

    test('get sharp sound mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((_) async {
        return 2;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getSoundMode();
      expect(mode, Sound.sharp, reason: 'unexpected sound mode');
    });

    test('get unknown sound mode', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((_) async {
        //since the returned value is 3 then the plugin should
        //return an error as this value does not map to a sound value
        return 3;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var error = 'no error';
      try {
        await scannerHandler.getSoundMode();
      } on Exception catch (e) {
        error = e.toString();
      }
      const expectedError = 'Exception: Unable to get sound mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

    test('get sound with error', () async {

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((_) async {
        /*
          the app cannot set parameter value. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var error = 'no error';
      try {
        await scannerHandler.getSoundMode();
      } on Exception catch (e) {
        error = e.toString();
      }
      const expectedError = 'Exception: Unable to get sound mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');

    });

  });

  group('set sound mode', () {

    test('set no sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.sendGoodReadBeepEnable.id);
        expect(mode, 0, reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.none);
    });

    test('set short sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.sendGoodReadBeepEnable.id);
        expect(mode, 1, reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.short);
    });

    test('set sharp sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.sendGoodReadBeepEnable.id);
        expect(mode, 2, reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.sharp);
    });

    test('set sound with error', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        /*
          the app cannot set parameter value. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var error = 'no error';
      try {
        await scannerHandler.setSoundMode(Sound.none);
      } on Exception catch (e) {
        error = e.toString();
      }
      const expectedError = 'Exception: Unable to set sound mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('is vibration enabled tests', () {

    test('is vibration enabled test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.sendGoodReadVibrateEnable.id,
            reason: 'unexpected property id');

        return 1;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final enabled = await scannerHandler.isVibrationEnabled();

      expect(enabled, isTrue, reason: 'unexpected vibration enabled value');
    });

    test('is vibration disabled test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.sendGoodReadVibrateEnable.id,
            reason: 'unexpected property id');

        return 0;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final enabled = await scannerHandler.isVibrationEnabled();

      expect(enabled, isFalse, reason: 'unexpected vibration enabled value');
    });

    test('is vibration with error test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        /*
          the app cannot get parameter value. Either the property id does
          not exist or the device does not have a scanner.
           */
        throw Exception('error');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var error = 'no error';
      try {
        await scannerHandler.isVibrationEnabled();
      } on Exception catch (e) {
        error = e.toString();
      }
      const expectedError = 'Exception: Unable to find vibration status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('enable vibration tests', () {

    test('enable vibration test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final enabled = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.sendGoodReadVibrateEnable.id,
            reason: 'unexpected property id');
        expect(enabled, 1, reason: 'unexpected enabled value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableVibration(enable: true);
    });

    test('disable vibration test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final enabled = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.sendGoodReadVibrateEnable.id,
            reason: 'unexpected property id');
        expect(enabled, 0, reason: 'unexpected enabled value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableVibration(enable: false);
    });

    test('set vibration with error test', () async {

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        /*
          the app cannot set parameter value. Either the property id does
          not exist or the device does not have a scanner.
           */
        throw Exception('error');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var error = 'no error';
      try {
        await scannerHandler.enableVibration(enable: true);
      } on Exception catch (e) {
        error = e.toString();
      }
      const expectedError = 'Exception: Unable to set vibration status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });
  });

  group('is trigger enabled tests', () {

    test('is trigger enabled test', () {
      //there it no logic in the is trigger enable function as the logic is
      //handled by the native side
    });

    test('is trigger enabled with error', () async {
      //check that the app handles an error correctly
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.isTriggerEnabled()).thenAnswer((_) async {
        /*
          the app cannot get trigger value. Either the property id does
          not exist or the device does not have a scanner.
           */
        throw Exception('error');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var error = 'no error';
      try {
        await scannerHandler.isTriggerEnabled();
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to find trigger status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });
  });

  group('enable trigger test', () {

    test('enable trigger test', () async {
      var enabled = false;
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.enableTrigger()).thenAnswer((_) async {
        enabled = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableTrigger(enable: true);
      expect(enabled, isTrue, reason: 'unexpected trigger enabled value');
    });

    test('disable trigger test', () async {
      var disable = false;
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.disableTrigger()).thenAnswer((_) async {
        disable = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableTrigger(enable: false);
      expect(disable, isTrue, reason: 'unexpected trigger disabled value');
    });

    test('set trigger with error', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.enableTrigger()).thenAnswer((_) async {
        /*
          the app cannot set trigger value. Either the property id does
          not exist or the device does not have a scanner.
           */
        throw Exception('error');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var error = 'no error';
      try {
        await scannerHandler.enableTrigger(enable: true);
      } on Exception catch(e) {
        error = e.toString();
      }
      const expectedError = 'Exception: Unable to set trigger status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('get scan mode test', () {

    test('get pulse mode test', () async {
      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getScanMode()).thenAnswer((_) async {
        return 0;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final scanMode = await scannerHandler.getScanMode();
      expect(scanMode, ScanMode.pulse, reason: 'unexpected scan mode');
    });

    test('get continuous mode test', () async {
      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getScanMode()).thenAnswer((_) async {
        return 1;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final scanMode = await scannerHandler.getScanMode();
      expect(scanMode, ScanMode.continuous, reason: 'unexpected scan mode');
    });

    test('get host mode test', () async {
      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getScanMode()).thenAnswer((_) async {
        return 2;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final scanMode = await scannerHandler.getScanMode();
      expect(scanMode, ScanMode.host, reason: 'unexpected scan mode');
    });

    test('get unknown mode test', () async {
      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getScanMode()).thenAnswer((_) async {
        return 3;
      });

      var error = 'no error';
      try {
        final scannerHandler = ScannerHandler(messageHandler: messageHandler);
        await scannerHandler.getScanMode();
      } on Exception catch(e){
        error = e.toString();
      }
      //the scan mode of 3 should not exist so a no scan mode
      //found error should be thrown
      const expectedError = 'Exception: Unable to get scan mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

    test('get scan mode with error', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getScanMode()).thenAnswer((_) async {
        /*
          the app cannot get scan mode. Either the property id does
          not exist or the device does not have a scanner.
           */
        throw Exception('error');
      });

      var error = 'no error';
      try {
        final scannerHandler = ScannerHandler(messageHandler: messageHandler);
        await scannerHandler.getScanMode();
      } on Exception catch(e){
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to get scan mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });
  });

  group('set scan mode tests', () {

    test('set scan mode to host test', () async {

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.setScanMode(any)).thenAnswer((mode) async {
        expect(mode.positionalArguments.first, 2,
            reason: 'unexpected scan mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setScanMode(ScanMode.host);

    });

    test('set scan mode to pulse test', () async {

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.setScanMode(any)).thenAnswer((mode) async {
        expect(mode.positionalArguments.first, 0,
            reason: 'unexpected scan mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setScanMode(ScanMode.pulse);

    });

    test('set scan mode to continuous test', () async {
      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.setScanMode(any)).thenAnswer((mode) async {
        expect(mode.positionalArguments.first, 1,
            reason: 'unexpected scan mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setScanMode(ScanMode.continuous);
    });

    test('set scan mode with error', () async {
      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.setScanMode(any)).thenAnswer((_) async {
        /*
          the app cannot set scan mode. Either the property id does
          not exist or the device does not have a scanner.
           */
        throw Exception('error');
      });

      const mode = ScanMode.host;
      var error = 'no error';
      try {
        final scannerHandler = ScannerHandler(messageHandler: messageHandler);
        await scannerHandler.setScanMode(mode);
      } on Exception catch(e){
        error = e.toString();
      }

      final expectedError = 'Exception: Unable set scan mode of ${mode.name}. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('get codes tests', () {
    test('get codes test', () async {
      final notSupported = Code(
        id: 1,
        type: 'Qr',
        supported: false,
        enabled: false,
      );

      //even though it is enabled on the native android side
      //it should be marked as not enabled
      final enabledButNotSupported = Code(
        id: 2,
        type: 'None',
        supported: false,
        enabled: true,
      );

      final notEnabled = Code(
        id: 3,
        type: 'barcode',
        supported: true,
        enabled: false,
      );

      final enabled = Code(
        id: 4,
        type: 'Aztec',
        supported: true,
        enabled: true,
      );

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getCodes()).thenAnswer((_) async {
        return [notSupported, enabledButNotSupported, notEnabled, enabled];
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final codes = await scannerHandler.getCodes();

      final foundNotSupported = codes
          .where((code) => code.id == notSupported.id)
          .firstOrNull;
      expect(foundNotSupported?.id, notSupported.id,
          reason: 'unexpected code id');
      expect(foundNotSupported?.type, notSupported.type,
          reason: 'unexpected code type');
      expect(foundNotSupported?.supported, isFalse,
          reason: 'unexpected code supported');
      //since it is not supported it cannot be enabled
      expect(foundNotSupported?.isEnabled(), isFalse,
          reason: 'unexpected code is enabled');

      final foundEnabledButNotSupported = codes
          .where((code) => code.id == enabledButNotSupported.id)
          .firstOrNull;
      expect(foundEnabledButNotSupported?.id, enabledButNotSupported.id,
          reason: 'unexpected code id');
      expect(foundEnabledButNotSupported?.type, enabledButNotSupported.type,
          reason: 'unexpected code type');
      expect(foundEnabledButNotSupported?.supported, isFalse,
          reason: 'unexpected code supported');
      //since it is not supported it cannot be enabled
      expect(foundEnabledButNotSupported?.isEnabled(), isFalse,
          reason: 'unexpected code is enabled');

      final foundNotEnabled = codes
          .where((code) => code.id == notEnabled.id)
          .firstOrNull;
      expect(foundNotEnabled?.id, notEnabled.id, reason: 'unexpected code id');
      expect(foundNotEnabled?.type, notEnabled.type,
          reason: 'unexpected code type');
      expect(foundNotEnabled?.supported, isTrue,
          reason: 'unexpected code supported');
      //even though supported is true enabled can still be false
      expect(foundNotEnabled?.isEnabled(), isFalse,
          reason: 'unexpected code is enabled');

      final foundEnabled = codes
          .where((code) => code.id == enabled.id)
          .firstOrNull;
      expect(foundEnabled?.id, enabled.id, reason: 'unexpected code id');
      expect(foundEnabled?.type, enabled.type, reason: 'unexpected code type');
      expect(foundEnabled?.supported, isTrue,
          reason: 'unexpected code supported');
      //both supported and enabled must be true for the code to be enabled
      expect(foundEnabled?.isEnabled(), isTrue,
          reason: 'unexpected code is enabled');
    });

    test('get codes with error', () async {

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getCodes()).thenAnswer((_) async {

        /*
          the app cannot get codes. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.getCodes();
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to get barcode types (codes). '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });
  });

  group('get code tests', () {
    test('get code test', () async {
      final messageHandler = MockUrovoMessageInterface();

      final expectedCode = Code(
          id: 0,
          type: 'QR',
          supported: true,
          enabled: false);

      when(messageHandler.getCode(any)).thenAnswer((_) async {
        return expectedCode;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final foundCode = await scannerHandler.getCode(expectedCode.id);

      expect(foundCode?.id, expectedCode.id, reason: 'unexpected code id');
      expect(
          foundCode?.type, expectedCode.type, reason: 'unexpected code type');
      expect(foundCode?.supported, isTrue,
          reason: 'unexpected code supported');
      expect(foundCode?.isEnabled(), isFalse,
          reason: 'unexpected code is enabled');
    });

    test('could not find code test', () async {

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getCode(any)).thenAnswer((_) async {
        return null;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final foundCode = await scannerHandler.getCode(1);

      //if the plugin cannot find a code it should just return null
      expect(foundCode, isNull, reason: 'unexpected code is not null');

    });

    test('get code with error', () async {

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getCode(any)).thenAnswer((_) async {
        /*
          the app cannot get code. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      const codeId = 1;
      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.getCode(codeId);
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable get code with id of $codeId. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');

    });

  });

  group('get supported codes tests', () {

    test('get supported codes test', () async {

      final notSupported = Code(
        id: 1,
        type: 'QR',
        supported: false,
        enabled: false,
      );

      final notEnabled = Code(
        id: 2,
        type: 'Barcode',
        supported: true,
        enabled: false,
      );

      final enabled = Code(
        id: 3,
        type: 'Aztec',
        supported: true,
        enabled: true,
      );

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getCodes()).thenAnswer((_) async {
        return [notSupported, notEnabled, enabled];
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final codes = await scannerHandler.getSupportedCodes();

      //the length should be 2 as one of the codes is not supported
      //it should not matter if the code is enabled or not
      expect(codes.length, 2, reason: 'unexpected codes length');

      final foundNotEnabled = codes
          .where((code) => code.id == notEnabled.id).firstOrNull;
      expect(foundNotEnabled?.id, notEnabled.id,
          reason: 'unexpected code id');

      final foundEnabled = codes
          .where((code) => code.id == enabled.id).firstOrNull;
      expect(foundEnabled?.id, enabled.id, reason: 'unexpected code id');

    });

  });

  group('get enabled codes tests', () {

    test('get enabled codes test', () async {

      final notSupported = Code(
        id: 1,
        type: 'Qr',
        supported: false,
        enabled: false,
      );

      //even though it is enabled on the native android side
      //it should be marked as not enabled
      final enabledButNotSupported = Code(
        id: 2,
        type: 'None',
        supported: false,
        enabled: true,
      );

      final notEnabled = Code(
        id: 3,
        type: 'barcode',
        supported: true,
        enabled: false,
      );

      final enabled = Code(
        id: 4,
        type: 'Aztec',
        supported: true,
        enabled: true,
      );

      final messageHandler = MockUrovoMessageInterface();

      when(messageHandler.getCodes()).thenAnswer((_) async {
        return [notSupported, enabledButNotSupported, notEnabled, enabled];
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final codes = await scannerHandler.getEnabledCodes();

      //the only codes that should be return should be both enabled and
      //supported
      expect(codes.length, 1, reason: 'unexpected code list length');

      expect(codes.firstOrNull?.id, enabled.id,
          reason: 'unexpected id found');

    });

  });

  group('enable code tests', () {

    test('enable code test', () async {

      final expectCode = c.Code(
        id: 1,
        type: 'QR',
        supported: true,
        enabled: false,
      );

      final messageHandler = MockUrovoMessageInterface();
      var codeEnabled = false;
      when(messageHandler.enableCode(any)).thenAnswer((codeId) async {
        expect(codeId.positionalArguments.first, expectCode.id,
            reason: 'unexpected code');
        codeEnabled = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enabledCode(code: expectCode, enable: true);

      expect(codeEnabled, isTrue, reason: 'unexpected enabled value');

    });

    test('disable code test', () async {
      final expectCode = c.Code(
        id: 1,
        type: 'QR',
        supported: true,
        enabled: true,
      );

      final messageHandler = MockUrovoMessageInterface();
      var codeEnabled = false;
      when(messageHandler.disableCode(any)).thenAnswer((codeId) async {
        expect(codeId.positionalArguments.first, expectCode.id,
            reason: 'unexpected code');
        codeEnabled = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enabledCode(code: expectCode, enable: false);

      expect(codeEnabled, isTrue, reason: 'unexpected enabled value');
    });

    test('set code with error test', () async {
      final expectCode = c.Code(
        id: 1,
        type: 'QR',
        supported: true,
        enabled: false,
      );

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.enableCode(any)).thenAnswer((_) async {
        /*
          the app cannot enable code. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.enabledCode(code: expectCode, enable: true);
      } on Exception catch(e) {
        error = e.toString();
      }

      final expectedError = 'Exception: Unable to enable ${expectCode.type}. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');

    });

  });

  group('enable all codes test', () {

    test('enable all codes test', () async {
      final messageHandler = MockUrovoMessageInterface();

      var codesEnabled = false;
      when(messageHandler.enableAllCodes()).thenAnswer((_) async {
        codesEnabled = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableAllCodes(enable: true);

      expect(codesEnabled, isTrue, reason: 'unexpected enabled value');
    });

    test('disable all codes test', () async {
      final messageHandler = MockUrovoMessageInterface();

      var codesDisabled = false;
      when(messageHandler.disableAllCodes()).thenAnswer((_) async {
        codesDisabled = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableAllCodes(enable: false);

      expect(codesDisabled, isTrue, reason: 'unexpected enabled value');
    });

    test('enable all codes with error', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.enableAllCodes()).thenAnswer((_) async {
        /*
          the app cannot enable all codes. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.enableAllCodes(enable: true);
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError =
          'Exception: Unable to enable all codes (barcode types). '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('get light mode tests', () {

    test('all off light mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');

        return 0;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getLightMode();
      expect(mode, LightMode.allOff, reason: 'unexpected light mode');
    });

    test('aimer only test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');

        return 1;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getLightMode();
      expect(mode, LightMode.aimerOnly, reason: 'unexpected light mode');
    });

    test('illumination only test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');

        return 2;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getLightMode();
      expect(mode, LightMode.illuminationOnly, reason: 'unexpected light mode');
    });

    test('alternating test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');

        return 3;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getLightMode();
      expect(mode, LightMode.alternating, reason: 'unexpected light mode');
    });

    test('concurrent test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        final id = input.positionalArguments.firstOrNull;
        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');

        return 4;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getLightMode();
      expect(mode, LightMode.concurrent, reason: 'unexpected light mode');
    });

    test('get unknown light mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        return 5;
      });

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.getLightMode();
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to get light mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

    test('get light mode with error test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any)).thenAnswer((input) async {
        /*
          the app cannot get light mode. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);

      try {
        await scannerHandler.getLightMode();
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to get light mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('set light mode tests', () {

    test('set all off test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');
        expect(mode, LightMode.allOff.id, reason: 'unexpected light mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setLightMode(LightMode.allOff);
    });

    test('set aimer only test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');
        expect(mode, LightMode.aimerOnly.id, reason: 'unexpected light mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setLightMode(LightMode.aimerOnly);
    });

    test('set illumination only test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');
        expect(mode, LightMode.illuminationOnly.id,
            reason: 'unexpected light mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setLightMode(LightMode.illuminationOnly);
    });

    test('set alternating test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');
        expect(mode, LightMode.alternating.id,
            reason: 'unexpected light mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setLightMode(LightMode.alternating);
    });

    test('set concurrent test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        final id = input.positionalArguments.firstOrNull;
        final mode = input.positionalArguments.lastOrNull;

        expect(id, PropertyId.dec2dLightsMode.id,
            reason: 'unexpected property id');
        expect(mode, LightMode.concurrent.id,
            reason: 'unexpected light mode');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setLightMode(LightMode.concurrent);
    });

    test('set light mode with error test', () async {

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        /*
          the app cannot set light mode. Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.setLightMode(LightMode.allOff);
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable to set light mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');

    });

  });

  group('get parameter value tests', () {

    test('get parameter value test', () async {
      //there it no logic in the set parameter value function as the logic is
      //handled by the native side
    });

    test('get parameter value with error test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getParameterValue(any,)).thenAnswer((input) async{
        /*
          Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      const propertyId = 1;

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.getParameterValue(propertyId);
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError =
          'Exception: Unable to get parameter value of $propertyId. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('set parameter value tests', () {

    test('set parameter value test', () async {
      //there it no logic in the set parameter value function as the logic is
      //handled by the native side
    });

    test('set parameter value with error test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setParameterValue(any, any)).thenAnswer((input) async{
        /*
          Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      const propertyId = 1;
      const value = 1;

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.setParameterValue(propertyId, value);
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError =
          'Exception: Unable to set parameter value of $propertyId, to $value. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });

  });

  group('reset scanner tests', () {

    test('reset scanner test', () async {
      //there it no logic in the reset scanner function as the logic is
      //handled by the native side
    });

    test('reset scanner with error test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.resetScanner()).thenAnswer((_) {
        /*
          Either the property id does
          not exist or the device does not have a scanner.
           */

        throw Exception('error');
      });

      var error = 'no error';
      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      try {
        await scannerHandler.resetScanner();
      } on Exception catch(e) {
        error = e.toString();
      }

      const expectedError = 'Exception: Unable reset scanner. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.';
      expect(error, expectedError, reason: 'unexpected error');
    });
  });
}
