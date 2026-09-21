import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:urovo_scanning/Barcode.dart' as b;
import 'package:urovo_scanning/Code.dart' as c;
import 'package:urovo_scanning/light_mode.dart';
import 'package:urovo_scanning/scan_mode.dart';
import 'package:urovo_scanning/sound.dart';
import 'package:urovo_scanning/src/property_id.dart';
import 'package:urovo_scanning/src/urovo_message_interface.g.dart';

///This handles the logic of converting the scanners response
class ScannerHandler {

  ///
  ScannerHandler({required UrovoMessageInterface messageHandler}) {
    _messageHandler = messageHandler;
  }

  late final UrovoMessageInterface _messageHandler;

  ///check if the smartphone can used the plugin
  Future<bool> isDeviceCompatible() async {
    //this plugin only works on urovo scanners which are android devices

    if (defaultTargetPlatform == TargetPlatform.android) {
      final manufacture = await _messageHandler.getDeviceManufacture();
      if (manufacture == 'Urovo') {

        return  true;//_isSupportedDevice();
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //might be useful in the future
  /*Future<bool> _isSupportedDevice() async {

    /*
    checks if the device is one that would have a built it scanner
     */

    final supported = [
      'DT50',
    ];

    final model = await _messageHandler.getDeviceModel();

    //print('Device model is $model');

    if (supported.where(model.contains).isNotEmpty) {
      //checks if the model is one of the supported devices
      //contains is used as there might be multiple variations of the same
      //device such as DT50 and DT50Q (as the Q marks the device as a subtype)
      return true;
    } else {
      return false;
    }
  }*/

  ///stream of barcodes of type string
  Stream<String> barcodeStringSteam() {
    final stream = barcodeStream().map((barcode) {
      return barcode.barcodeAsString;
    });
    return stream;
  }

  ///stream of barcodes as byte list
  Stream<Uint8List> barcodeBytesStream() {
    final stream = barcodeStream().map((barcode) {
      return barcode.bytes;
    });
    return stream;
  }

  ///steam of all information related to a scanned barcode
  Stream<b.Barcode> barcodeStream() {
    final stream = onBarcodeChanged().map((barcode) {
      return b.Barcode(
          bytes: barcode.bytes,
          barcodeAsString: barcode.barcodeAsString,
          length: barcode.length,
          code: barcode.code,
          type: barcode.type);
    });
    return stream;
  }

  ///an image of the most recently scanned barcode
  Stream<Uint8List> barcodeImageStream() {
    return onBarcodeImageChanged();
  }

  ///start a scan programmatically
  Future<void> startScanning() async {
    try {
      await _messageHandler.startScanning();
    } on Exception {
      throw Exception('Unable to start scanning. '
          'This might be because the device has already started scanning, '
          'the device does not have a built in scanner '
          'or is not a UROVO device.');
    }
  }

  ///stop a scan programmatically
  Future<void> stopScanning() async {
    try {
      await _messageHandler.stopScanning();
    } on Exception {
      throw Exception('Unable to stop scanning. '
          'This might be because the device has already stopped scanning, '
          'the device does not have a built in scanner '
          'or is not a UROVO device.');
    }
  }

  ///turn off power to the barcode reader
  Future<void> closeScanner() async {
    try {
      await _messageHandler.closeScanner();
    } on Exception {
      throw Exception('Unable to close scanner. '
          'This might be because the device has already closed scanner, '
          'the device does not have a built in scanner '
          'or is not a UROVO device.');
    }
  }

  ///get the maximum amount of time that the scanner can be on for
  Future<double> getTimeout() async {
    try {
      final time = 
      await getParameterValue(PropertyId.laserOnTime.id);

      //the time is returned in tenths of seconds (i.e. 100ms)
      // so 10 equals 1 second
      //so time is divided by 10 and rounded to 2 decimal places
      final mod = pow(10, 2).toDouble();
      return ((time / 10) * mod).round().toDouble() / mod;
    } on Exception {
      throw Exception('Unable to get time out. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///set the maximum amount of time that the scanner can be on for
  Future<void> setTimeout(double timeout) async {
    //the timeout value should be set to a 1 tenth of a second ( 100 ms) scale
    //so 1 second becomes 10

    try {
      final scaledTimeOut = (timeout * 10).round();
      await setParameterValue(PropertyId.laserOnTime.id, scaledTimeOut);
    } on Exception {
      throw Exception('Unable to set time out. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///get what sound the scanner will make if it successfully
  Future<Sound> getSoundMode() async {
    try {
      final id = await getParameterValue(PropertyId.sendGoodReadBeepEnable.id);
      //0 : None
      //1 : Short
      //2 : Sharp
      final mode = Sound.values
          .where((mode) => mode.id == id).firstOrNull;
      if (mode == null) {
        throw Exception('unknown sound mode');
      } else {
        return mode;
      }
    } on Exception {
      throw Exception('Unable to get sound mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///set what sound the scanner will make if it successfully
  Future<void> setSoundMode(Sound mode) async {

    try {
      return
        await setParameterValue(PropertyId.sendGoodReadBeepEnable.id, mode.id);
    } on Exception {
      throw Exception('Unable to set sound mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///check if the scanner will vibrate if the scan is successful
  Future<bool> isVibrationEnabled() async {
    try {
      final result =
      await getParameterValue(PropertyId.sendGoodReadVibrateEnable.id);

      //0 is disabled
      //1 is enabled
      return result == 1;
    } on Exception {
      throw Exception('Unable to find vibration status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///set if the scanner will vibrate if the scan is successful
  Future<void> enableVibration({required bool enable}) async {
    try {
      final int vibrate;
      if (enable) {
        vibrate = 1;
      } else {
        vibrate = 0;
      }

      await setParameterValue(PropertyId.sendGoodReadVibrateEnable.id, vibrate);
    } on Exception {
      throw Exception('Unable to set vibration status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///check if the scanner's buttons are enabled
  Future<bool> isTriggerEnabled() async {
    try {
      return await _messageHandler.isTriggerEnabled();
    } on Exception {
      throw Exception('Unable to find trigger status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///set if the scanner's buttons are enabled
  Future<void> enableTrigger({required bool enable}) async {
    try {
      if (enable) {
        await _messageHandler.enableTrigger();
      } else {
        await _messageHandler.disableTrigger();
      }
    } on Exception {
      throw Exception('Unable to set trigger status. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///get the current scan mode
  Future<ScanMode> getScanMode() async {
    try {
      final id = await _messageHandler.getScanMode();
      final mode = ScanMode.values
          .where((mode) => mode.id == id)
          .firstOrNull;
      if (mode == null) {
        throw Exception('unknown scan mode');
      } else {
        return mode;
      }
    } on Exception catch(_) {
      throw Exception('Unable to get scan mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///set the current scan mode
  Future<void> setScanMode(ScanMode mode) async {

    try {
      await _messageHandler.setScanMode(mode.id);
    } on Exception {
      throw Exception('Unable set scan mode of ${mode.name}. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///get the types of barcodes the scanner is able to scan
  Future<List<c.Code>> getCodes() async {
    try {
      final codes = await _messageHandler.getCodes();
      return codes.map((code) {
        return c.Code(
            id: code.id,
            type: code.type,
            supported: code.supported,
            enabled: code.enabled);
      }).toList();
    } on Exception {
      throw Exception('Unable to get barcode types (codes). '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///get single barcode type
  Future<c.Code?> getCode(int codeId) async {
    try {
      final code = await _messageHandler.getCode(codeId);
      if (code == null) {
        return null;
      }
      return c.Code(
          id: code.id,
          type: code.type,
          supported: code.supported,
          enabled: code.enabled);
    } on Exception {
      throw Exception('Unable get code with id of $codeId. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///get the types of barcodes that scanner can scan
  Future<List<c.Code>> getSupportedCodes() async {
    return (await getCodes()).where((code) => code.supported).toList();
  }

  ///get the types of barcodes that the scanner is allowed to scan
  Future<List<c.Code>> getEnabledCodes() async {
    return (await getCodes()).where((code) => code.isEnabled()).toList();
  }

  ///enable or disable a specific barcode type
  Future<void> enabledCode({required c.Code code, required bool enable}) async {
    try {
      if (enable) {
        await _messageHandler.enableCode(code.id);
      } else {
        await _messageHandler.disableCode(code.id);
      }
    } on Exception {
      throw Exception('Unable to enable ${code.type}. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///disables all code so the scanner is stopped from reading any code
  Future<void> enableAllCodes({required bool enable}) async {
    try {
      if (enable) {
        await _messageHandler.enableAllCodes();
      } else {
        await _messageHandler.disableAllCodes();
      }
    } on Exception {
      throw Exception('Unable to enable all codes (barcode types). '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///get barcode scanner light mode
  Future<LightMode> getLightMode() async {
    try {
      final config = await getParameterValue(PropertyId.dec2dLightsMode.id);
      final mode = LightMode.values
          .where((mode) => mode.id == config).firstOrNull;
      if (mode == null) {
        throw Exception('unknown light mode');
      } else {
        return mode;
      }
    } on Exception {
      throw Exception('Unable to get light mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///set barcode scanner light options
  Future<void> setLightMode(LightMode mode) async {
    try {
      await setParameterValue(PropertyId.dec2dLightsMode.id, mode.id);
    } on Exception {
      throw Exception('Unable to set light mode. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///set parameter value of scanner
  Future<void> setParameterValue(int propertyId, int value) async {
    try {
      await _messageHandler.setParameterValue(propertyId, value);
    } on Exception {
      throw Exception(
          'Unable to set parameter value of $propertyId, to $value. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///get scanner parameter value
  Future<int> getParameterValue(int propertyId) async {
    try {
      final result = await _messageHandler
          .getParameterValue(propertyId);
      return result;
    } on Exception {
      throw Exception('Unable to get parameter value of $propertyId. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

  ///reset all scanner settings to the default
  Future<void> resetScanner() async {
    try {
      await _messageHandler.resetScanner();
    } on Exception {
      throw Exception('Unable reset scanner. '
          'This might be because the device does not have '
          'a built in scanner or is not a UROVO device.');
    }
  }

}
