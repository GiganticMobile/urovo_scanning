import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class ScannerTimeoutSettings extends StatefulWidget {
  const ScannerTimeoutSettings({super.key});

  @override
  State<ScannerTimeoutSettings> createState() => _ScannerTimeoutSettingsState();
}

class _ScannerTimeoutSettingsState extends State<ScannerTimeoutSettings> {

  double? _timOutInSeconds;

  @override
  void initState() {
    super.initState();
    UrovoScanning().getTimeout().then((value) {
      //convert value from milliseconds to seconds
      setState(() {
        _timOutInSeconds = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
        title: Text("Scan time out"),
        subtitle: Text("The time (in seconds) the scanner "
            "should stay on before automatically turning off."),
      children: [
        Text("Time out is ${(_timOutInSeconds ?? 1).toStringAsPrecision(3)} seconds"),
        Slider(
          value: _timOutInSeconds ?? 1,
          min: 1,
          max: 10,
          onChanged: _timOutInSeconds != null ? (double value) {
            setState(() {
              _timOutInSeconds = value;
            });
          } : null,
          onChangeEnd: _timOutInSeconds != null ? (value) {
            if (_timOutInSeconds != null) {
              UrovoScanning().setTimeout(_timOutInSeconds!);
            }
          } : null,)
      ],
    );
  }
}
