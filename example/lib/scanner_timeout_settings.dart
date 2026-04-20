import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///this sets how long the scanner should stay active without scanning anything
class ScannerTimeoutSettings extends StatefulWidget {
  ///
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
      if (mounted) {
        setState(() {
          _timOutInSeconds = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
        title: const Text('Scan time out'),
        subtitle: const Text('The time (in seconds) the scanner '
            'should stay on before automatically turning off.'),
      children: [
        Text('Time out is '
            '${(_timOutInSeconds ?? 1).toStringAsPrecision(3)} seconds'),
        Slider(
          value: _timOutInSeconds ?? 1,
          min: 1,
          max: 10,
          onChanged: _timOutInSeconds != null ? (value) {
            setState(() {
              _timOutInSeconds = value;
            });
          } : null,
          onChangeEnd: _timOutInSeconds != null ? (value) async {
            if (_timOutInSeconds != null) {
              await UrovoScanning().setTimeout(_timOutInSeconds!);
            }
          } : null,)
      ],
    );
  }
}
