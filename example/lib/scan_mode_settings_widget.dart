import 'package:flutter/material.dart';
import 'package:urovo_scanning/scan_mode.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///set how the scanner should act when it is turned on
class ScanModeSettingsWidget extends StatefulWidget {
  ///
  const ScanModeSettingsWidget({super.key});

  @override
  State<ScanModeSettingsWidget> createState() => _ScanModeSettingsWidgetState();
}

class _ScanModeSettingsWidgetState extends State<ScanModeSettingsWidget> {

  //the current mode the scanner is set to
  ScanMode? _mode;

  @override
  void initState() {
    super.initState();
    UrovoScanning().getScanMode().then((value) {
      if (mounted) {
        setState(() {
          _mode = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    //host mode is when the scanner is only active when the user presses a scan button
    final hostModeEnabled = _mode == ScanMode.host;

    //pulse mode is when the scanner only turns on for a short period of time
    final pulseModeEnabled = _mode == ScanMode.pulse;

    //continuous mode is when the scanner it turned on and stays on until
    //the user presses the scan button
    final continuousMode = _mode == ScanMode.continuous;

    return ExpansionTile(
      title: const Text('Scan mode'),
      subtitle: const Text('Each scan mode can be automatically '
          'cancelled by the on device time out'),
      children: [
        SwitchListTile(
            title: const Text('Host mode'),
            subtitle: const Text('This is when the scanner is only active when '
                'the user is pressing a scan button'),
            value: hostModeEnabled,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning().setScanMode(ScanMode.host);

              final value = await UrovoScanning().getScanMode();

              if (mounted) {
                setState(() {
                  _mode = value;
                });
              }
            } : null),

        SwitchListTile(
            title: const Text('Pulse mode'),
            subtitle: const Text('This is when the scanner is only active '
                'for a short period of time'),
            value: pulseModeEnabled,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning().setScanMode(ScanMode.pulse);

              final value = await UrovoScanning().getScanMode();

              if (mounted) {
                setState(() {
                  _mode = value;
                });
              }
            } : null),

        SwitchListTile(
            title: const Text('Continuous mode'),
            subtitle: const Text('This is when the scanner is constantly active and '
                'only turned off when a scan button is pressed'),
            value: continuousMode,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning().setScanMode(ScanMode.continuous);

              final value = await UrovoScanning().getScanMode();

              if (mounted) {
                setState(() {
                  _mode = value;
                });
              }
            } : null),
      ],
    );
  }
}
