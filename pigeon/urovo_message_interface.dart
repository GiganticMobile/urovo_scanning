import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    input: 'pigeon/urovo_message_interface.dart',
    dartOut: 'lib/urovo_message_interface.g.dart',
    dartOptions: DartOptions(),
    //cppOptions: CppOptions(namespace: 'pigeon_example'),
    //cppHeaderOut: 'windows/runner/messages.g.h',
    //cppSourceOut: 'windows/runner/messages.g.cpp',
    //gobjectHeaderOut: 'linux/messages.g.h',
    //gobjectSourceOut: 'linux/messages.g.cc',
    //gobjectOptions: GObjectOptions(),
    kotlinOut:
    'android/src/main/kotlin/com/gigantic_tickets/urovo_scanning/urovo_message_interface.g.kt',
    kotlinOptions: KotlinOptions(),
    //javaOut: 'android/app/src/main/java/io/flutter/plugins/Messages.java',
    //javaOptions: JavaOptions(),
    //swiftOut: 'ios/Runner/Messages.g.swift',
    //swiftOptions: SwiftOptions(),
    //objcHeaderOut: 'macos/Runner/messages.g.h',
    //objcSourceOut: 'macos/Runner/messages.g.m',
    // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
    //objcOptions: ObjcOptions(prefix: 'PGN'),
    //copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'urovo_scanning_package',
  ),
)

@HostApi()
abstract class UrovoMessageInterface {

  @async
  String getDeviceManufacture();

  //this allows the plugin to start a scan whenever the user
  //wants.
  //optional delay which if null defaults to 5 seconds
  void startScanning(int? delay);

  //this stops an already in progress scan
  void stopScanning();

  @async
  int getTimeOut();

  void setTimeOut(int timeout);

  @async
  SoundMode getSoundMode();

  void setSoundMode(SoundMode mode);

  @async
  bool isVibrationEnabled();

  void enableVibration();

  void disableVibration();

  @async
  bool isTriggerEnabled();

  //this enables the physical scan buttons on the device
  void enableTrigger();

  //this disables the physical scan buttons on the device
  void disableTrigger();

  @async
  TriggerMode getTriggerMode();

  void setTriggerMode(TriggerMode mode);

  @async
  List<SymbologyCode> getSymbology();

  void enableSymbology(SymbologyCode code);

  void disableSymbology(SymbologyCode code);

  void resetScanner();
}

@EventChannelApi()
abstract class UrovoBarcodeInterface {

  BarcodeInfo onBarcodeChanged();

}

class BarcodeInfo {
  final Uint8List barcodeBytes;
  final String barcode;
  final int length;
  final int type;

  BarcodeInfo({
    required this.barcodeBytes,
    required this.barcode,
    required this.length,
    required this.type,
  });
}

enum SoundMode {

  //no sound
  NONE,
  //
  SHORT,
  //
  SHARP,

}

enum TriggerMode {
  //The scanner is only in operation as long as the physical scanning button is pressed
  HOST,

  //The scanner is only in operation for a short period of time after the physical
  // scanning button is pressed
  PULSE,

  //The scanner is in operation as soon as the physical scanning button is
  // pressed as it only turned off when these buttons are pressed again
  CONTINUOUS
}

//Symbology is the kinds of codes the laser scanner is able to read
class SymbologyCode {
  //used as identification
  String title;
  //the id of the code the scanner understands
  int index;
  //if this code has been enabled
  bool enabled;

  SymbologyCode({
    required this.title,
    required this.index,
    required this.enabled,
  });
}

//run pigeon command
//dart run pigeon --input pigeon/urovo_message_interface.dart