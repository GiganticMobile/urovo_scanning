import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_message_interface.g.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class ScanModeSettingsWidget extends StatefulWidget {
  const ScanModeSettingsWidget({super.key});

  @override
  State<ScanModeSettingsWidget> createState() => _ScanModeSettingsWidgetState();
}

class _ScanModeSettingsWidgetState extends State<ScanModeSettingsWidget> {

  //the current mode the scanner is set to
  TriggerMode? _mode;

  @override
  void initState() {
    super.initState();
    UrovoScanning().getTriggerMode().then((value) {
      setState(() {
        _mode = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    //host mode is when the scanner is only active when the user presses a scan button
    final hostModeEnabled = _mode == TriggerMode.HOST;

    //pulse mode is when the scanner only turns on for a short period of time
    final pulseModeEnabled = _mode == TriggerMode.PULSE;

    //continuous mode is when the scanner it turned on and stays on until
    //the user presses the scan button
    final continuousMode = _mode == TriggerMode.CONTINUOUS;

    return ExpansionTile(
      title: Text("Scan mode"),
      subtitle: Text("Each scan mode can be automatically "
          "cancelled by the on device time out"),
      children: [
        SwitchListTile(
            title: Text("Host mode"),
            subtitle: Text("This is when the scanner is only active when "
                "the user is pressing a scan button"),
            value: hostModeEnabled,
            onChanged: _mode != null ? (value) {
              UrovoScanning().setTriggerMode(TriggerMode.HOST);

              UrovoScanning().getTriggerMode().then((value) {
                setState(() {
                  _mode = value;
                });
              });
            } : null),

        SwitchListTile(
            title: Text("Pulse mode"),
            subtitle: Text("This is when the scanner is only active "
                "for a short period of time"),
            value: pulseModeEnabled,
            onChanged: _mode != null ? (value) {
              UrovoScanning().setTriggerMode(TriggerMode.PULSE);

              UrovoScanning().getTriggerMode().then((value) {
                setState(() {
                  _mode = value;
                });
              });
            } : null),

        SwitchListTile(
            title: Text("Continuous mode"),
            subtitle: Text("This is when the scanner is constantly active and "
                "only turned off when a scan button is pressed"),
            value: continuousMode,
            onChanged: _mode != null ? (value) {
              UrovoScanning().setTriggerMode(TriggerMode.CONTINUOUS);

              UrovoScanning().getTriggerMode().then((value) {
                setState(() {
                  _mode = value;
                });
              });
            } : null),
      ],
    );
  }
}
