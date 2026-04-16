import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class ResetScannerSettings extends StatelessWidget {
  const ResetScannerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.warning),
      title: Text("Reset scanner"),
      subtitle: Text("Reset scanner to default settings"),
      onTap: () {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text("Are you sure you want to reset the scanner"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('Cancel')),
              TextButton(onPressed: () {
                Navigator.of(context).pop();
                UrovoScanning().resetScanner();
              }, child: Text('Reset')),
            ],
          );
        });
      },
    );
  }
}
