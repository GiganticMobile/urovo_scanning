import 'package:pigeon/pigeon.dart';

//run pigeon flutter pub run pigeon --input pigeon/urovo_message_interface.dart
@ConfigurePigeon(
  PigeonOptions(
    input: 'pigeon/urovo_message_interface.dart',
    dartOut: 'lib/src/urovo_message_interface.g.dart',
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
    // Set this to a unique prefix for your plugin or application,
    // per Objective-C naming conventions.
    //objcOptions: ObjcOptions(prefix: 'PGN'),
    //copyrightHeader: 'pigeons/copyright.txt',
    dartPackageName: 'urovo_scanning_package',
  ),
)

@HostApi()
abstract class UrovoMessageInterface {

  /*@async
  bool hasDeviceScanner();*/

  @async
  String getDeviceManufacture();

  @async
  String getDeviceModel();

  //this allows the plugin to start a scan whenever the user
  //wants.
  void startScanning();

  //this stops an already in progress scan
  void stopScanning();

  @async
  int getTimeOut();

  void setTimeOut(int timeout);

  @async
  int? getSoundMode();

  void setSoundMode(int mode);

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
  int? getScanMode();

  void setScanMode(int mode);

  @async
  List<Code> getCodes();

  @async
  Code? getCode(int codeId);

  void enableCode(int codeId);

  void enableAllCodes();

  void disableCode(int codeId);

  void disableAllCodes();

  void resetScanner();
}

///
@EventChannelApi()
abstract class UrovoBarcodeInterface {

  Barcode onBarcodeChanged();

}

///Barcode information returned by a scan
class Barcode {

  ///
  Barcode({
    required this.bytes,
    required this.barcodeAsString,
    required this.length,
    required this.code,
    required this.type,
  });

  final Uint8List? bytes;
  final String? barcodeAsString;
  final int? length;
  final String? code;
  final int? type;

}

///this represent a type of barcode (this is only used for communicating
///with the native code i.e. kotlin)
class Code {

  ///
  Code({
    required this.id,
    required this.type,
    required this.supported,
    required this.enabled
  });

  ///the format id
  final int id;

  ///the format type of the barcode
  final String type;

  ///is the barcode supported by the scanner
  final bool supported;

  ///is the type enabled
  final bool enabled;


}

//run pigeon command
//dart run pigeon --input pigeon/urovo_message_interface.dart
