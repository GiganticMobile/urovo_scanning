import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:urovo_scanning/urovo_message_interface.g.dart';

class UrovoScanning {

  Future<bool> isDeviceCompatible() async {
    //this plugin onl works on urovo scanners which are android devices

    if (defaultTargetPlatform == TargetPlatform.android) {
      final messageHandler = UrovoMessageInterface();
      final manufacture = await messageHandler.getDeviceManufacture();
      if (manufacture == "Urovo") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Stream<BarcodeInfo> barcodeStream() {
    final stream = onBarcodeChanged();
    return stream;
  }

  void startScanning(int? delay) {
    UrovoMessageInterface().startScanning(delay);
  }

  void stopScanning() {
    UrovoMessageInterface().stopScanning();
  }

  Future<double> getTimeout() async {
    final time = await UrovoMessageInterface().getTimeOut();

    //the time is returned in tenths of seconds so 10 equals 1 second
    //so time is divided by 10 and rounded to 2 decimal places
    double mod = pow(10, 2).toDouble();
    return (((time / 10) * mod).round().toDouble() / mod);
  }

  void setTimeout(double timeout) {
    //the timeout value should be set to a 1 tenth of a second scale
    //so 1 second becomes 10

    final scaledTimeOut = (timeout * 10).round();
    UrovoMessageInterface().setTimeOut(scaledTimeOut);
  }

  Future<SoundMode> getSoundMode() async {
    return UrovoMessageInterface().getSoundMode();
  }

  void setSoundMode(SoundMode mode) async {
    return UrovoMessageInterface().setSoundMode(mode);
  }

  Future<bool> isVibrationEnabled() async {
    return UrovoMessageInterface().isVibrationEnabled();
  }

  void enableVibration() {
    UrovoMessageInterface().enableVibration();
  }

  void disableVibration() {
    UrovoMessageInterface().disableVibration();
  }

  Future<bool> isTriggerEnabled() {
    return UrovoMessageInterface().isTriggerEnabled();
  }

  void enableTrigger() {
    UrovoMessageInterface().enableTrigger();
  }

  void disableTrigger() {
    UrovoMessageInterface().disableTrigger();
  }

  Future<TriggerMode> getTriggerMode() async {
    return UrovoMessageInterface().getTriggerMode();
  }

  void setTriggerMode(TriggerMode mode) {
    UrovoMessageInterface().setTriggerMode(mode);
  }

  Future<List<SymbologyCode>> getSymbology() async {
    final codes = await UrovoMessageInterface().getSymbology();
    return codes;
  }

  void enabledSymbology(SymbologyCode code) {
    UrovoMessageInterface().enableSymbology(code);
  }

  void disableSymbology(SymbologyCode code) {
    UrovoMessageInterface().disableSymbology(code);
  }

  void resetScanner() {
    UrovoMessageInterface().resetScanner();
  }
}
