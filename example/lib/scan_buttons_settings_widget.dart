import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class ScanButtonsSettingsWidget extends StatefulWidget {
  const ScanButtonsSettingsWidget({super.key});

  @override
  State<ScanButtonsSettingsWidget> createState() => _ScanButtonsSettingsWidgetState();
}

class _ScanButtonsSettingsWidgetState extends State<ScanButtonsSettingsWidget> {

  bool? _scanButtonsEnabled;

  @override
  void initState() {
    super.initState();
    UrovoScanning().isTriggerEnabled().then((value) {
      setState(() {
        _scanButtonsEnabled = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    /*
    Enable and disable the scan action buttons on the device.
    So if disabled the device will not scan.
     */

    var isEnableText = "unknown";
    if (_scanButtonsEnabled == true) {
      isEnableText = "Enabled";
    } else if (_scanButtonsEnabled == false) {
      isEnableText = "Disabled";
    } else {
      isEnableText = "unknown";
    }

    return SwitchListTile(
        title: Text("Are the scan buttons enabled?"),
        subtitle: Text(isEnableText),
        value: _scanButtonsEnabled ?? false,
        onChanged: _scanButtonsEnabled != null ? (value) {

          if (value) {
            UrovoScanning().enableTrigger();
          } else {
            UrovoScanning().disableTrigger();
          }

          UrovoScanning().isTriggerEnabled().then((value) {
            setState(() {
              _scanButtonsEnabled = value;
            });
          });
        } : null);
  }
}
