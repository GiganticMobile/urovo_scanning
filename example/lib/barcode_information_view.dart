import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_message_interface.g.dart';

class BarcodeInformationView extends StatelessWidget {
  const BarcodeInformationView({
    required BarcodeInfo barcodeInfo,
    super.key}) : _barcodeInfo = barcodeInfo;

  final BarcodeInfo _barcodeInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        //the barcode as string
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_barcodeInfo.barcode,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        ),

        //barcode data as a list of bytes
        ListTile(
          title: Text("Barcode in Bytes"),
          subtitle: Text((_barcodeInfo.barcodeBytes).isNotEmpty
              ? _barcodeInfo.barcodeBytes.toString()
              : "unknown"),
        ),

        //length of the byte list length
        ListTile(
          title: Text("Barcode Length"),
          subtitle: Text(_barcodeInfo.length.toString()),
        ),

        //type of barcode
        ListTile(
          title: Text("Barcode type"),
          subtitle: Text(_barcodeInfo.length.toString()),
        ),

    ],);
  }
}
