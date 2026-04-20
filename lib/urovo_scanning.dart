import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:urovo_scanning/Barcode.dart' as b;
import 'package:urovo_scanning/Code.dart' as c;
import 'package:urovo_scanning/Sound.dart';
import 'package:urovo_scanning/scan_mode.dart';
import 'package:urovo_scanning/src/urovo_message_interface.g.dart';

///Plug in for the Urovo scanner
class UrovoScanning {

  ///check if the smartphone can used the plugin
  Future<bool> isDeviceCompatible() async {
    //this plugin only works on urovo scanners which are android devices

    if (defaultTargetPlatform == TargetPlatform.android) {
      final messageHandler = UrovoMessageInterface();
      final manufacture = await messageHandler.getDeviceManufacture();
      if (manufacture == 'Urovo') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

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

  ///start a scan programmatically
  Future<void> startScanning() async {
    await UrovoMessageInterface().startScanning();
  }

  ///stop a scan programmatically
  Future<void> stopScanning() async {
    await UrovoMessageInterface().stopScanning();
  }

  ///get the maximum amount of time that the scanner can be on for
  Future<double> getTimeout() async {
    final time = await UrovoMessageInterface().getTimeOut();

    //the time is returned in tenths of seconds so 10 equals 1 second
    //so time is divided by 10 and rounded to 2 decimal places
    final mod = pow(10, 2).toDouble();
    return ((time / 10) * mod).round().toDouble() / mod;
  }

  ///set the maximum amount of time that the scanner can be on for
  Future<void> setTimeout(double timeout) async {
    //the timeout value should be set to a 1 tenth of a second scale
    //so 1 second becomes 10

    final scaledTimeOut = (timeout * 10).round();
    await UrovoMessageInterface().setTimeOut(scaledTimeOut);
  }

  ///get what sound the scanner will make if it successfully
  /// scans a barcode
  /// the options are
  /// none (no sound)
  /// short sound
  /// sharp sound
  Future<Sound> getSoundMode() async {
    final id = await UrovoMessageInterface().getSoundMode();
    //0 : None
    //1 : Short
    //2 : Sharp
    if (id == 0) {
      return Sound.none;
    } else if (id == 1) {
      return Sound.short;
    } else if (id == 2) {
      return Sound.sharp;
    } else {
      return Sound.none;
    }
  }

  ///set what sound the scanner will make if it successfully
  /// scans a barcode
  /// the options are
  /// none (no sound)
  /// short sound
  /// sharp sound
  Future<void> setSoundMode(Sound mode) async {

    final int id;
    switch(mode) {
      case Sound.none:
        id = 0;
      case Sound.short:
        id = 1;
      case Sound.sharp:
        id = 2;
    }

    return UrovoMessageInterface().setSoundMode(id);
  }

  ///check if the scanner will vibrate if the scan is successful
  Future<bool> isVibrationEnabled() async {
    return UrovoMessageInterface().isVibrationEnabled();
  }

  ///set if the scanner will vibrate if the scan is successful
  Future<void> enableVibration({required bool enable}) async {
    if (enable) {
      await UrovoMessageInterface().enableVibration();
    } else {
      await UrovoMessageInterface().disableVibration();
    }
  }

  ///check if the scanner's buttons are enabled
  Future<bool> isTriggerEnabled() {
    return UrovoMessageInterface().isTriggerEnabled();
  }

  ///set if the scanner's buttons are enabled
  Future<void> enableTrigger({required bool enable}) async {
    if (enable) {
      await UrovoMessageInterface().enableTrigger();
    } else {
      await UrovoMessageInterface().disableTrigger();
    }
  }

  ///get the current scan mode
  ///check ScanMode
  Future<ScanMode> getScanMode() async {
    final id = await UrovoMessageInterface().getScanMode();

    if (id == 0) {
      return ScanMode.pulse;
    } else if (id == 1) {
      return ScanMode.continuous;
    } else if (id == 2) {
      return ScanMode.host;
    } else {
      return ScanMode.host;
    }
  }

  ///get the current scan mode
  ///check ScanMode
  Future<void> setScanMode(ScanMode mode) async {

    final int id;
    switch(mode) {
      case ScanMode.host:
        id = 2;
      case ScanMode.pulse:
        id = 0;
      case ScanMode.continuous:
        id = 1;
    }

    await UrovoMessageInterface().setScanMode(id);
  }

  ///get the types of barcodes the scanner is able to scan
  Future<List<c.Code>> getCodes() async {
    final codes = await UrovoMessageInterface().getCodes();
    return codes.map((code) {
      return c.Code(
          id: code.id,
          type: code.type,
          supported: code.supported,
          enabled: code.enabled);
    }).toList();
  }

  ///get single barcode type
  Future<c.Code?> getCode(int codeId) async {
    final code = await UrovoMessageInterface().getCode(codeId);
    if (code == null) {
      return null;
    }
    return c.Code(
        id: code.id,
        type: code.type,
        supported: code.supported,
        enabled: code.enabled);
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
    if (enable) {
      await UrovoMessageInterface().enableCode(code.id);
    } else {
      await UrovoMessageInterface().disableCode(code.id);
    }
  }

  ///disables all code so the scanner is stopped from reading any code
  Future<void> enableAllCodes({required bool enable}) async {
    if (enable) {
      await UrovoMessageInterface().enableAllCodes();
    } else {
      await UrovoMessageInterface().disableAllCodes();
    }
  }

  ///reset all scanner settings to the default
  Future<void> resetScanner() async {
    await UrovoMessageInterface().resetScanner();
  }
}
