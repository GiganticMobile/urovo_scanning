import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/Barcode.dart';
import 'package:urovo_scanning/urovo_scanning.dart';
import 'package:urovo_scanning_example/scan_screen/barcode_image_widget.dart';
import 'package:urovo_scanning_example/scan_screen/barcode_information_widget.dart';
import 'package:urovo_scanning_example/scan_screen/scan_button.dart';
import 'package:urovo_scanning_example/settings_screen/settings_screen.dart';

///scan screen
class ScanScreen extends StatefulWidget {
  ///
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(

          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        title: const Text('Scanning'),
                        actions: [

                          IconButton(onPressed: () {
                            //go to settings screen
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          }, icon: const Icon(Icons.settings))
                        ],
                      ),
                      SliverToBoxAdapter(
                          child: StreamBuilder(
                              initialData: Uint8List.fromList([]),
                              ///Stream of List of bytes which are mages of
                              ///successfully scanned barcodes
                              stream: UrovoScanning().barcodeImageStream(),
                              builder: (context, snapshot) {
                                final imageBytes =
                                    snapshot.data ?? Uint8List.fromList([]);

                                return BarcodeImageWidget(
                                    imageBytes: imageBytes);
                              })
                      ),

                      StreamBuilder(
                          initialData: Barcode(
                              bytes: Uint8List.fromList([]),
                              barcodeAsString: '',
                              length: 0,
                              code: '',
                              type: 0),
                          ///Stream of all the informatio related to a
                          ///successfully scanned barcode
                          stream: UrovoScanning().barcodeStream(),
                          builder: (context, snapshot) {
                            final barcodeInfo = snapshot.data ?? Barcode(
                                bytes: Uint8List.fromList([]),
                                barcodeAsString: '',
                                length: 0,
                                code: '',
                                type: 0);
                            return BarcodeInformationWidget(
                                barcode: barcodeInfo);
                          })
                    ]),
              ),
              ScanButton(
                onStart: () {
                  //start scanning programmatically
                  unawaited(UrovoScanning().startScanning());
                },
                onStop: () {
                  //stop scanning programmatically
                  unawaited(UrovoScanning().stopScanning());
                },
              )
            ],),
        )
    );
  }
}
