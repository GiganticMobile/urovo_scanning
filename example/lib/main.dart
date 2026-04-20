import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/Barcode.dart';
import 'package:urovo_scanning/urovo_scanning.dart';
import 'package:urovo_scanning_example/barcode_information_view.dart';
import 'package:urovo_scanning_example/barcode_types_settings.dart';
import 'package:urovo_scanning_example/device_compatible_view.dart';
import 'package:urovo_scanning_example/reset_scanner_settings.dart';
import 'package:urovo_scanning_example/scan_action_buttons.dart';
import 'package:urovo_scanning_example/scan_buttons_settings_widget.dart';
import 'package:urovo_scanning_example/scan_mode_settings_widget.dart';
import 'package:urovo_scanning_example/scanner_sound_settings.dart';
import 'package:urovo_scanning_example/scanner_timeout_settings.dart';
import 'package:urovo_scanning_example/scanner_vibrate_setting.dart';

void main() {
  runApp(const ExampleApp());
}

///
class ExampleApp extends StatelessWidget {
  ///
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScanScreen(),
    );
  }
}

///
class ScanScreen extends StatefulWidget {
  ///
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  //initial barcode information
  var _barcodeInformation = Barcode(
      bytes: Uint8List.fromList([]),
      barcodeAsString: '',
      length: 0,
      code: '',
      type: 0);

  late final StreamSubscription<Barcode>
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
                showModalBottomSheet<void>(context: context, builder: (context) {
                  return ListView(children: [
                    ListTile(
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.close),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const DeviceCompatibleView(),
                    const ScannerTimeoutSettings(),
                    const ScannerSoundSettings(),
                    const ScannerVibrateSetting(),
                    const ScanModeSettingsWidget(),
                    const ScanButtonsSettingsWidget(),
                    const UniversalBarcodeTypeSettings(),
                    const BarcodeTypesSettings(),
                    const ResetScannerSettings(),
                  ],);
                });

              }, icon: const Icon(Icons.settings))
            ],),
          body: Column(children: [
            Expanded(child: Center(child: BarcodeInformationView(
              barcodeInfo: _barcodeInformation,
            ))),
            ScanActionButtons(clearResultAction: () {
              setState(() {
                //clearing barcode information
                _barcodeInformation = Barcode(
                    bytes: Uint8List.fromList([]),
                    barcodeAsString: '',
                    length: 0,
                    code: '',
                    type: 0);
              });
            })
          ],),
        ));
  }
}
