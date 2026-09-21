import 'dart:async';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/light_mode.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///set the light mode of the barcode scanner
class ScannerLightModeSettings extends StatefulWidget {
  ///
  const ScannerLightModeSettings({super.key});

  @override
  State<ScannerLightModeSettings> createState() =>
      _ScannerLightModeSettingsState();
}

class _ScannerLightModeSettingsState extends State<ScannerLightModeSettings> {

  //the current light mode the scanner is set to
  LightMode? _mode;

  @override
  void initState() {
    super.initState();
    unawaited(
        UrovoScanning().getLightMode().then((value) {
          if (mounted) {
            setState(() {
              _mode = value;
            });
          }
        }, onError: (error) {
          //catch error but do nothing
        })
    );
  }

  @override
  Widget build(BuildContext context) {

    final allOffEnabled = LightMode.allOff == _mode;
    final aimerOnlyEnabled = LightMode.aimerOnly == _mode;
    final illuminationOnlyEnabled = LightMode.illuminationOnly == _mode;
    final alternatingEnabled = LightMode.alternating == _mode;
    final concurrentEnabled = LightMode.concurrent == _mode;

    return ExpansionTile(
        title: const Text('Light mode'),
      subtitle: const Text('Light options for the built in scanner'),
      children: [
        SwitchListTile(
            title: const Text('All off'),
            subtitle: const Text('When scanning the light and '
                'the laser aim assist will not turn on.'),
            value: allOffEnabled,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning().setLightMode(mode: LightMode.allOff);

              final value = await UrovoScanning().getLightMode();

              if (mounted) {
                setState(() {
                  _mode = value;
                });
              }
            } : null),

        SwitchListTile(
            title: const Text('Aimer Only'),
            subtitle: const Text('When scanning the light is off '
                'and the laser aim assist will turn on.'),
            value: aimerOnlyEnabled,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning().setLightMode(mode: LightMode.aimerOnly);

              final value = await UrovoScanning().getLightMode();

              if (mounted) {
                setState(() {
                  _mode = value;
                });
              }
            } : null),

        SwitchListTile(
            title: const Text('Illumination Only'),
            subtitle: const Text('When scanning the light is on '
                'and the laser aim assist will be off.'),
            value: illuminationOnlyEnabled,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning()
                  .setLightMode(mode: LightMode.illuminationOnly);

              final value = await UrovoScanning().getLightMode();

              if (mounted) {
                setState(() {
                  _mode = value;
                });
              }
            } : null),

        SwitchListTile(
            title: const Text('Alternating'),
            subtitle: const Text('When scanning the light is on '
                'and the laser aim assist will be on.'),
            value: alternatingEnabled,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning().setLightMode(mode: LightMode.alternating);

              final value = await UrovoScanning().getLightMode();

              if (mounted) {
                setState(() {
                  _mode = value;
                });
              }
            } : null),

        SwitchListTile(
            title: const Text('Concurrent'),
            subtitle: const Text('When scanning the light is on '
                'and the laser aim assist will be on.'),
            value: concurrentEnabled,
            onChanged: _mode != null ? (value) async {
              await UrovoScanning().setLightMode(mode: LightMode.concurrent);

              final value = await UrovoScanning().getLightMode();

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
