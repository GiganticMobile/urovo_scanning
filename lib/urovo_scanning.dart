import 'package:flutter/foundation.dart';
import 'package:urovo_scanning/Barcode.dart' as b;
import 'package:urovo_scanning/Code.dart' as c;
import 'package:urovo_scanning/Sound.dart';
import 'package:urovo_scanning/scan_mode.dart';
import 'package:urovo_scanning/src/scanner_handler.dart';
import 'package:urovo_scanning/src/urovo_message_interface.g.dart';
import 'package:urovo_scanning/src/urovo_scanning_interface.dart';

///Plug in for the Urovo scanner
class UrovoScanning implements UrovoScanningInterface {

  ///
  UrovoScanning() {
    _scannerHandler = ScannerHandler(messageHandler: UrovoMessageInterface());
  }

  late final ScannerHandler _scannerHandler;

  @override
  Future<bool> isDeviceCompatible() {
    return _scannerHandler.isDeviceCompatible();
  }

  @override
  Stream<Uint8List> barcodeBytesStream() {
    return _scannerHandler.barcodeBytesStream();
  }

  @override
  Stream<b.Barcode> barcodeStream() {
    return _scannerHandler.barcodeStream();
  }

  @override
  Stream<String> barcodeStringSteam() {
    return _scannerHandler.barcodeStringSteam();
  }

  @override
  Stream<Uint8List> barcodeImageStream() {
    return _scannerHandler.barcodeImageStream();
  }

  @override
  Future<void> enableAllCodes({required bool enable}) {
    return _scannerHandler.enableAllCodes(enable: enable);
  }

  @override
  Future<void> enableTrigger({required bool enable}) {
    return _scannerHandler.enableTrigger(enable: enable);
  }

  @override
  Future<void> enableVibration({required bool enable}) {
    return _scannerHandler.enableVibration(enable: enable);
  }

  @override
  Future<void> enabledCode({required c.Code code, required bool enable}) {
    return _scannerHandler.enabledCode(code: code, enable: enable);
  }

  @override
  Future<c.Code?> getCode(int codeId) {
    return _scannerHandler.getCode(codeId);
  }

  @override
  Future<List<c.Code>> getCodes() {
    return _scannerHandler.getCodes();
  }

  @override
  Future<List<c.Code>> getEnabledCodes() {
    return _scannerHandler.getEnabledCodes();
  }

  @override
  Future<ScanMode> getScanMode() {
    return _scannerHandler.getScanMode();
  }

  @override
  Future<Sound> getSoundMode() {
    return _scannerHandler.getSoundMode();
  }

  @override
  Future<List<c.Code>> getSupportedCodes() {
    return _scannerHandler.getSupportedCodes();
  }

  @override
  Future<double> getTimeout() {
    return _scannerHandler.getTimeout();
  }

  @override
  Future<bool> isTriggerEnabled() {
    return _scannerHandler.isTriggerEnabled();
  }

  @override
  Future<bool> isVibrationEnabled() {
    return _scannerHandler.isVibrationEnabled();
  }

  @override
  Future<void> resetScanner() {
    return _scannerHandler.resetScanner();
  }

  @override
  Future<void> setScanMode(ScanMode mode) {
    return _scannerHandler.setScanMode(mode);
  }

  @override
  Future<void> setSoundMode(Sound mode) {
    return _scannerHandler.setSoundMode(mode);
  }

  @override
  Future<void> setTimeout(double timeout) {
    return _scannerHandler.setTimeout(timeout);
  }

  @override
  Future<void> startScanning() {
    return _scannerHandler.startScanning();
  }

  @override
  Future<void> stopScanning() {
    return _scannerHandler.stopScanning();
  }

  @override
  Future<void> closeScanner() {
    return _scannerHandler.closeScanner();
  }
}
