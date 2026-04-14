
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
