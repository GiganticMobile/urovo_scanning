import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';
import 'package:urovo_scanning_example/scan_screen/scan_screen.dart';

/*
The example app for urovo devices with built in barcode
readers.
 */

void main() {
  runApp(const ExampleApp());
}

///
class ExampleApp extends StatefulWidget {
  ///
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {

  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onDetach: () async {
        final urovoScanning = UrovoScanning();
        if (await urovoScanning.isDeviceCompatible()) {
          //if device is compatible turn off scanner before closing.
          await urovoScanning.closeScanner();
        }
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScanScreen(),
    );
  }
}
