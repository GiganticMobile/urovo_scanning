import 'dart:async';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///enable or disable the physical scan action buttons on the device
class ScanButtonsSettingsWidget extends StatefulWidget {
  ///
  const ScanButtonsSettingsWidget({super.key});

  @override
  State<ScanButtonsSettingsWidget> createState() => _ScanButtonsSettingsWidgetState();
}

class _ScanButtonsSettingsWidgetState extends State<ScanButtonsSettingsWidget> {

  bool? _scanButtonsEnabled;

  @override
  void initState() {
    super.initState();
    unawaited(
        UrovoScanning().isTriggerEnabled().then((value) {
          if (mounted) {
            setState(() {
              _scanButtonsEnabled = value;
            });
          }
        }, onError: (error) {
          //catch error but do nothing
        })
    );
  }

  @override
  Widget build(BuildContext context) {

    /*
    Enable and disable the scan action buttons on the device.
    So if disabled the device will not scan.
     */

    var isEnableText = 'unknown';
    if (_scanButtonsEnabled == true) {
      isEnableText = 'Enabled';
    } else if (_scanButtonsEnabled == false) {
      isEnableText = 'Disabled';
    } else {
      isEnableText = 'unknown';
    }

    return SwitchListTile(
        title: const Text('Are the scan buttons enabled?'),
        subtitle: Text(isEnableText),
        value: _scanButtonsEnabled ?? false,
        onChanged: _scanButtonsEnabled != null ? (value) async {

          await UrovoScanning().enableTrigger(enable: value);

          final scanButtonEnabled = await UrovoScanning().isTriggerEnabled();

          if (mounted) {
            setState(() {
              _scanButtonsEnabled = scanButtonEnabled;
            });
          }
        } : null);
  }
}
