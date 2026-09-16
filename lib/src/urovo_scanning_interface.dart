
import 'dart:typed_data';

import 'package:urovo_scanning/Barcode.dart';
import 'package:urovo_scanning/Code.dart';
import 'package:urovo_scanning/Sound.dart';
import 'package:urovo_scanning/scan_mode.dart';

///this is exist to clarify what the plugin can and cannot do
abstract class UrovoScanningInterface {

  ///check if the smartphone can used the plugin
  ///If true then the device has a required feature (that of a urovo scanner)
  ///needed to used the plugin
  Future<bool> isDeviceCompatible();

  ///stream of barcodes of type string
  Stream<String> barcodeStringSteam();

  ///stream of barcodes as byte list
  Stream<Uint8List> barcodeBytesStream();

  ///steam of all information related to a scanned barcode
  ///If the scan is successful the stream will return [Barcode]
  Stream<Barcode> barcodeStream();

  ///stream of all the images taken when scanning a barcode.
  Stream<Uint8List> barcodeImageStream();

  ///start a scan programmatically
  ///For example start a scan with a UI button press
  ///<br />When started the scanner will automatically turn off if the
  ///scanner's time out is reached.
  Future<void> startScanning();

  ///stop a scan programmatically
  ///For example stopping a scan with a UI button press
  Future<void> stopScanning();

  ///turn off power to the barcode reader
  ///<br />Warning closing the scanner will disrupt any of the streams
  ///the plugin provides. So ensure closing the scanner is the last
  ///thing the app does.
  ///<br />There is no open version as the plugin tries to open the scanner
  ///when the app starts to interact with it.
  Future<void> closeScanner();

  ///get the maximum amount of time that the scanner can be on for
  Future<double> getTimeout();

  ///set the maximum amount of time that the scanner can be on for
  Future<void> setTimeout(double timeout);

  ///get what sound the scanner will make if it successfully
  /// scans a barcode
  /// <br /> options
  /// + none (no sound)
  /// + short sound
  /// + sharp sound
  Future<Sound> getSoundMode();

  ///set what sound the scanner will make if it successfully
  /// scans a barcode
  /// <br /> options
  /// + none (no sound)
  /// + short sound
  /// + sharp sound
  Future<void> setSoundMode(Sound mode);

  ///check if the scanner will vibrate if the scan is successful
  Future<bool> isVibrationEnabled();

  ///set if the scanner will vibrate if the scan is successful
  Future<void> enableVibration({required bool enable});

  ///check if the scanner's buttons are enabled
  Future<bool> isTriggerEnabled();

  ///set if the scanner's buttons are enabled
  Future<void> enableTrigger({required bool enable});

  ///get the current scan mode
  ///<br />options
  ///+ host: only turns on as long as the scan button is pressed
  ///+ pulse: once turned on the scanner stays on for a set amount of time
  ///+ continuous: once turned on the scanner will stay on until the scan
  ///buttons are pressed again (i.e press the scan button once to turn on then
  ///once again to turn off).
  Future<ScanMode> getScanMode();

  ///set the current scan mode
  ///<br />options
  ///+ host: only turns on as long as the scan button is pressed
  ///+ pulse: once turned on the scanner stays on for a set amount of time
  ///+ continuous: once turned on the scanner will stay on until the scan
  ///buttons are pressed again (i.e press the scan button once to turn on then
  ///once again to turn off).
  Future<void> setScanMode(ScanMode mode);

  ///get the types of barcodes the scanner is able to scan
  ///This should return a list of [Code] containing the type and if the
  ///scanner supports it and is allowed to scan it
  Future<List<Code>> getCodes();

  ///get single barcode type based on it's id
  ///if found it should return a [Code] if it does not exist
  ///then it will return null
  Future<Code?> getCode(int codeId);

  ///get the types of barcodes that scanner can scan
  ///This should return a list of [Code] that are supported by the scanner
  Future<List<Code>> getSupportedCodes();

  ///get the types of barcodes that the scanner is allowed to scan
  ///This should return a list of [Code] that are both supported by the
  ///scanner and that the scanner is allowed to scan (is enabled)
  Future<List<Code>> getEnabledCodes();

  ///enable or disable a specific barcode type
  Future<void> enabledCode({required Code code, required bool enable});

  ///enable or disables all [Code] that are supported by the scanner
  Future<void> enableAllCodes({required bool enable});

  ///reset all scanner settings to the default
  Future<void> resetScanner();
}
