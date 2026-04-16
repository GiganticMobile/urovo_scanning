import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class DeviceCompatibleView extends StatelessWidget {
  const DeviceCompatibleView({super.key});

  /*
  Checks if the smartphone could be compatible with the plugin
   */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UrovoScanning().isDeviceCompatible(),
        builder: (context, value) {
          var result = "unknown";
          if (value.data == true) {
            result = "Device is compatible";
          } else if (value.data == false) {
            result = "Not compatible";
          } else {
            result = "unknown";
          }

          return ListTile(
            title: Text("Is device compatible"),
            subtitle: Text(result),
          );
        });
  }
}
