import 'dart:async';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/sound.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///set the sound the scanner makes when is successfully scans a barcode
class ScannerSoundSettings extends StatefulWidget {
  ///
  const ScannerSoundSettings({super.key});

  @override
  State<ScannerSoundSettings> createState() => _ScannerSoundSettingsState();
}

class _ScannerSoundSettingsState extends State<ScannerSoundSettings> {

  Sound? _sound;

  @override
  void initState() {
    super.initState();
    unawaited(
        UrovoScanning().getSoundMode().then((value) {
          if (mounted) {
            setState(() {
              _sound = value;
            });
          }
        }, onError: (error) {
          //catch error but do nothing
        })
    );
  }

  @override
  Widget build(BuildContext context) {

    final noSound = _sound == Sound.none;
    final shortSound = _sound == Sound.short;
    final sharpSound = _sound == Sound.sharp;

    return ExpansionTile(
        title: const Text('Scanner sound'),
      subtitle: const Text('The sound the scanner makes when it '
          'successfully scans a barcode.'),
      children: [
        SwitchListTile(
            title: const Text('No sound'),
            value: noSound,
            onChanged: (value) async {
              try {
                await UrovoScanning().setSoundMode(Sound.none);

                final value = await UrovoScanning().getSoundMode();

                if (mounted) {
                  setState(() {
                    _sound = value;
                  });
                }
              } on Exception {
                //catch but do nothing
              }
            }),

        SwitchListTile(
            title: const Text('Short sound'),
            value: shortSound,
            onChanged: (value) async {
              await UrovoScanning().setSoundMode(Sound.short);

              final value = await UrovoScanning().getSoundMode();

              if (mounted) {
                setState(() {
                  _sound = value;
                });
              }
            }),

        SwitchListTile(
            title: const Text('Sharp sound'),
            value: sharpSound,
            onChanged: (value) async {
              await UrovoScanning().setSoundMode(Sound.sharp);

              final value = await UrovoScanning().getSoundMode();

              if (mounted) {
                setState(() {
                  _sound = value;
                });
              }
            }),
      ],
    );
  }
}
