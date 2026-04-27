import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:urovo_scanning/Code.dart' as c;
import 'package:urovo_scanning/Sound.dart';
import 'package:urovo_scanning/scan_mode.dart';
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

  group('start scanning tests', () {

    //there it no logic in the start scanning function as the logic is
    //handled by the native side

  });

  group('stop scanning tests', () {
    //there it no logic in the stop scanning function as the logic is
    //handled by the native side
  });

  group('get time out tests', () {

    test('get time out test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getTimeOut()).thenAnswer((_) async {
        /*
        the time out is returned in 10ths of a second i.e. 100ms
         */
        return 50;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final timeOut = await scannerHandler.getTimeout();
      expect(timeOut, 5.0, reason: 'unable to get time out');
    });

  });

  group('set time out test', () {

    test('set time out test', () async {

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setTimeOut(any)).thenAnswer((timeout) async {
        expect(timeout.positionalArguments.first, 50,
            reason: 'unexpected time out value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setTimeout(5);

    });

  });

  group('get sound mode tests', () {

    test('get no sound mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getSoundMode()).thenAnswer((_) async {
        return 0;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getSoundMode();
      expect(mode, Sound.none, reason: 'unexpected sound mode');
    });

    test('get short sound mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getSoundMode()).thenAnswer((_) async {
        return 1;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getSoundMode();
      expect(mode, Sound.short, reason: 'unexpected sound mode');
    });

    test('get sharp sound mode test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getSoundMode()).thenAnswer((_) async {
        return 2;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      final mode = await scannerHandler.getSoundMode();
      expect(mode, Sound.sharp, reason: 'unexpected sound mode');
    });

    test('get unknown sound mode', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.getSoundMode()).thenAnswer((_) async {
        //since the returned value is 3 then the plugin should
        //return an error as this value does not map to a sound value
        return 3;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      var errorOccurred = false;
      try {
        await scannerHandler.getSoundMode();
        errorOccurred = false;
      } on Exception catch (_) {
        errorOccurred = true;
      }
      //if mode is null then error occurred
      expect(errorOccurred, true, reason: 'unexpected no error occurred');
    });

  });

  group('set sound mode', () {

    test('set no sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setSoundMode(any)).thenAnswer((mode) async {
        expect(mode.positionalArguments.first, 0,
            reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.none);
    });

    test('set short sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setSoundMode(any)).thenAnswer((mode) async {
        expect(mode.positionalArguments.first, 1,
            reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.short);
    });

    test('set sharp sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setSoundMode(any)).thenAnswer((mode) async {
        expect(mode.positionalArguments.first, 2,
            reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.sharp);
    });

  });

  group('is vibration enabled tests', () {
    //there it no logic in the is vibration enable function as the logic is
    //handled by the native side
  });

  group('enable vibration tests', () {

    test('enable vibration test', () async {
      var enabled = false;
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.enableVibration()).thenAnswer((_) async {
        enabled = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableVibration(enable: true);
      expect(enabled, isTrue, reason: 'unexpected vibration enabled value');
    });

    test('disable vibration test', () async {
      var disable = false;
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.disableVibration()).thenAnswer((_) async {
        disable = true;
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.enableVibration(enable: false);
      expect(disable, isTrue, reason: 'unexpected vibration disabled value');
    });

  });

  group('is trigger enabled tests', () {
    //there it no logic in the is trigger enable function as the logic is
    //handled by the native side
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

      var errorFound = false;
      try {
        final scannerHandler = ScannerHandler(messageHandler: messageHandler);
        await scannerHandler.getScanMode();
      } on Exception {
        errorFound = true;
      }
      //the scan mode of 3 should not exist so a no scan mode
      //found error should be thrown
      expect(errorFound, isTrue, reason: 'unexpected error not thrown');
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

    group('enabled code tests', () {

      test('enabled code test', () async {

        final messageHandler = MockUrovoMessageInterface();

        final expectCode = c.Code(
          id: 1,
          type: 'QR',
          supported: true,
          enabled: false,
        );

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
        final messageHandler = MockUrovoMessageInterface();

        final expectCode = c.Code(
          id: 1,
          type: 'QR',
          supported: true,
          enabled: true,
        );

        var codeDisabled = false;
        when(messageHandler.disableCode(any)).thenAnswer((codeId) async {
          expect(codeId.positionalArguments.first, expectCode.id,
              reason: 'unexpected code');
          codeDisabled = true;
        });

        final scannerHandler = ScannerHandler(messageHandler: messageHandler);
        await scannerHandler.enabledCode(code: expectCode, enable: false);

        expect(codeDisabled, isTrue, reason: 'unexpected enabled value');
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

    });

  group('reset scanner tests', () {
    //there it no logic in the reset scanner function as the logic is
    //handled by the native side
  });
}
