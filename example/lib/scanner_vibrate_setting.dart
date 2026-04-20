import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///set if the scanner should vibrate if it successfully scans a barcode
class ScannerVibrateSetting extends StatefulWidget {
  ///
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
      if (mounted) {
        setState(() {
          _isVibrationEnabled = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: const Text('Scanner vibration'),
        subtitle: const Text('Should the scanner vibrates if it '
            'successfully scans a barcode.'),
        value: _isVibrationEnabled ?? false,
        onChanged: _isVibrationEnabled != null ? (value) async {
          await UrovoScanning().enableVibration(enable: value);

          final isVibrateEnabled = await UrovoScanning().isVibrationEnabled();

          if (mounted) {
            setState(() {
              _isVibrationEnabled = isVibrateEnabled;
            });
          }
        } : null);
  }
}
