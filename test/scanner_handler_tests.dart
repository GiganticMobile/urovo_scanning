import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:urovo_scanning/Sound.dart';
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

  /*group("barcode stream tests", () {

    test("barcode string stream test", () {

      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler)

    });

  });*/

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
        expect(timeout, 50, reason: 'unexpected time out value');
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
        expect(mode, 0, reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.none);
    });

    test('set short sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setSoundMode(any)).thenAnswer((mode) async {
        expect(mode, 1, reason: 'unexpected sound value');
      });

      final scannerHandler = ScannerHandler(messageHandler: messageHandler);
      await scannerHandler.setSoundMode(Sound.short);
    });

    test('set sharp sound test', () async {
      final messageHandler = MockUrovoMessageInterface();
      when(messageHandler.setSoundMode(any)).thenAnswer((mode) async {
        expect(mode, 2, reason: 'unexpected sound value');
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
}
