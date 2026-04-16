import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_message_interface.g.dart';
import 'package:urovo_scanning/urovo_scanning.dart';
import 'package:urovo_scanning_example/barcode_information_view.dart';
import 'package:urovo_scanning_example/device_compatible_view.dart';
import 'package:urovo_scanning_example/reset_scanner_settings.dart';
import 'package:urovo_scanning_example/scan_action_buttons.dart';
import 'package:urovo_scanning_example/scan_buttons_settings_widget.dart';
import 'package:urovo_scanning_example/scan_mode_settings_widget.dart';
import 'package:urovo_scanning_example/scanner_sound_settings.dart';
import 'package:urovo_scanning_example/scanner_timeout_settings.dart';
import 'package:urovo_scanning_example/scanner_vibrate_setting.dart';

import 'barcode_types_settings.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScanScreen(),
    );
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  //initial barcode information
  var _barcodeInformation = BarcodeInfo(
      barcodeBytes: Uint8List.fromList([]),
      barcode: '',
      length: 0,
      type: 0);

  late final StreamSubscription<BarcodeInfo>
  _barcodeInformationStreamSubscription;

  @override
  void initState() {
    super.initState();
    _barcodeInformationStreamSubscription =
    UrovoScanning().barcodeStream().listen((barcodeInformation) {
      setState(() {
        _barcodeInformation = barcodeInformation;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _barcodeInformationStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Urovo scanning app'),
            actions: [
              IconButton(onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return ListView(children: [
                    ListTile(
                      title: Text("Settings"),
                      trailing: Icon(Icons.close),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    DeviceCompatibleView(),
                    ScannerTimeoutSettings(),
                    ScannerSoundSettings(),
                    ScannerVibrateSetting(),
                    ScanModeSettingsWidget(),
                    ScanButtonsSettingsWidget(),
                    BarcodeTypesSettings(),
                    ResetScannerSettings(),
                  ],);
                });

              }, icon: Icon(Icons.settings))
            ],),
          body: Column(children: [
            Expanded(child: Center(child: BarcodeInformationView(
              barcodeInfo: _barcodeInformation,
            ))),
            ScanActionButtons(clearResultAction: () {
              setState(() {
                //clearing barcode information
                _barcodeInformation = BarcodeInfo(
                    barcodeBytes: Uint8List.fromList([]),
                    barcode: '',
                    length: 0,
                    type: 0);
              });
            })
          ],),
        ));
  }
}
