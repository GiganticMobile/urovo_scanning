import 'package:flutter/material.dart';
import 'package:urovo_scanning/Barcode.dart';

///this displays some general information about a scanned barcode
class BarcodeInformationView extends StatelessWidget {
  ///
  const BarcodeInformationView({
    required Barcode barcodeInfo,
    super.key}) : _barcodeInfo = barcodeInfo;

  final Barcode _barcodeInfo;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [
          //the barcode as string
          SliverAppBar(
            title: Text(_barcodeInfo.barcodeAsString,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
              automaticallyImplyLeading: false,
          ),

          SliverList.list(children: [
            //barcode data as a list of bytes
            ListTile(
              title: const Text('Barcode in Bytes'),
              subtitle: Text(_barcodeInfo.bytes.isNotEmpty
                  ? _barcodeInfo.bytes.toString()
                  : 'unknown'),
            ),

            //length of the byte list length
            ListTile(
              title: const Text('Barcode Length'),
              subtitle: Text(_barcodeInfo.length.toString()),
            ),

            //type of code as string
            ListTile(
              title: const Text('Barcode code'),
              subtitle: Text(_barcodeInfo.code),
            ),

            //type of barcode
            ListTile(
              title: const Text('Barcode type'),
              subtitle: Text(_barcodeInfo.length.toString()),
            ),
          ])
        ]
    );
  }
}
