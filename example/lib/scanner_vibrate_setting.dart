import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class ScannerVibrateSetting extends StatefulWidget {
  const ScannerVibrateSetting({super.key});

  @override
  State<ScannerVibrateSetting> createState() => _ScannerVibrateSettingState();
}

class _ScannerVibrateSettingState extends State<ScannerVibrateSetting> {

  bool? _isVibrationEnabled;

  @override
  void initState() {
    super.initState();
    UrovoScanning().isVibrationEnabled().then((value) {
      setState(() {
        _isVibrationEnabled = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text('Scanner vibration'),
        subtitle: Text("Should the scanner vibrates if it "
            "successfully scans a barcode."),
        value: _isVibrationEnabled ?? false,
        onChanged: _isVibrationEnabled != null ? (value) {
          if (value) {
            UrovoScanning().enableVibration();
          } else {
            UrovoScanning().disableVibration();
          }

          UrovoScanning().isVibrationEnabled().then((value) {
            setState(() {
              _isVibrationEnabled = value;
            });
          });
        } : null);
  }
}
