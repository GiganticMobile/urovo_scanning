import 'package:urovo_scanning/light_mode.dart';

///
enum PropertyId {

  ///Set the maximum time decode processing continues during a scan attempt.
  laserOnTime(40),
  ///set the noise the device makes when it successfully scans a barcode.
  sendGoodReadBeepEnable(6),
  ///set if the device vibrates makes when it successfully scans a barcode
  sendGoodReadVibrateEnable(7),
  ///set the light mode [LightMode] of the barcode scanner.
  dec2dLightsMode(2851);

  const PropertyId(this.id);

  ///
  final int id;

}
