import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///buttons that control the scanning functionality with the UI
class ScanActionButtons extends StatelessWidget {
  ///
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
          onPressed: () async {
            await UrovoScanning().startScanning();
          },
          label: const Text('Start'),
          icon: const Icon(Icons.barcode_reader),),

        FilledButton.icon(
          onPressed: () async {
            await UrovoScanning().stopScanning();
          },
          label: const Text('Stop'),
          icon: const Icon(Icons.stop),),

        FilledButton.icon(
          onPressed: _clearResultAction.call,
          label: const Text('Clear'),
          icon: const Icon(Icons.clear),),
      ],);
  }
}
