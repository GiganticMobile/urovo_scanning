import 'package:flutter/material.dart';
import 'package:urovo_scanning/Barcode.dart';

///displays general information of a scanned barcode
class BarcodeInformationWidget extends StatelessWidget {
  ///
  const BarcodeInformationWidget({required this.barcode, super.key});

  ///the barcode information from the scan
  final Barcode barcode;

  @override
  Widget build(BuildContext context) {
    return SliverList.list(children: [
        //barcode string
        ListTile(
          title: const Text('Barcode'),
          subtitle: Text(barcode.barcodeAsString),
        ),
        //barcode data as a list of bytes
        ListTile(
          title: const Text('Barcode in Bytes'),
          subtitle: Text(barcode.bytes.toString()),
        ),
        //length of the byte list length
        ListTile(
          title: const Text('Barcode Length'),
          subtitle: Text(barcode.length.toString()),
        ),
        //type of code as string
        ListTile(
          title: const Text('Barcode code'),
          subtitle: Text(barcode.code),
        ),
        //type of barcode
        ListTile(
          title: const Text('Barcode type'),
          subtitle: Text(barcode.type.toString()),
        ),
      ]);
  }
}
