import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class ScanActionButtons extends StatelessWidget {
  const ScanActionButtons({
    required VoidCallback clearResultAction,
    super.key}) : _clearResultAction = clearResultAction;

  final VoidCallback _clearResultAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton.icon(
          onPressed: () {
            //the delay represents how long the scanner should stat on for.
            //if the scanner gets a result it will automatically turn off
            //if the delay is reached then the scanner is turned off
            //if the delay is null then the delay defaults to 5 seconds
            //the delay does not override the device's default time out delay
            final int? delay = null;
            UrovoScanning().startScanning(delay);
          },
          label: Text("Start"),
          icon: Icon(Icons.barcode_reader),),

        FilledButton.icon(
          onPressed: () {
            UrovoScanning().stopScanning();
          },
          label: Text("Stop"),
          icon: Icon(Icons.stop),),

        FilledButton.icon(
          onPressed: () {
            _clearResultAction.call();
          },
          label: Text("Clear"),
          icon: Icon(Icons.clear),),
      ],);
  }
}
