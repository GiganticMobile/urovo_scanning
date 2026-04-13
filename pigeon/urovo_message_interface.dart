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

}

@EventChannelApi()
abstract class UrovoBarcodeInterface {

  String onBarcodeChanged();

}

//run pigeon command
//dart run pigeon --input pigeon/urovo_message_interface.dart