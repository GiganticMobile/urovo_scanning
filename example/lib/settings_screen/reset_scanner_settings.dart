import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///this resets the scanner to it's default settings
class ResetScannerSettings extends StatelessWidget {
  ///
  const ResetScannerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.warning),
      title: const Text('Reset scanner'),
      subtitle: const Text('Reset scanner to default settings'),
      onTap: () {
        showDialog<void>(context: context, builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure you want to reset the scanner'),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text('Cancel')),
              TextButton(onPressed: () {
                Navigator.of(context).pop();
                UrovoScanning().resetScanner();
              }, child: const Text('Reset')),
            ],
          );
        });
      },
    );
  }
}
