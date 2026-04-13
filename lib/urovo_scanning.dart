
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
}
