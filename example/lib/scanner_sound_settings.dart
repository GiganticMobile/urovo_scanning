import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_message_interface.g.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class ScannerSoundSettings extends StatefulWidget {
  const ScannerSoundSettings({super.key});

  @override
  State<ScannerSoundSettings> createState() => _ScannerSoundSettingsState();
}

class _ScannerSoundSettingsState extends State<ScannerSoundSettings> {

  SoundMode? _sound;

  @override
  void initState() {
    super.initState();
    UrovoScanning().getSoundMode().then((value) {
      setState(() {
        _sound = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final noSound = _sound == SoundMode.NONE;
    final shortSound = _sound == SoundMode.SHORT;
    final sharpSound = _sound == SoundMode.SHARP;

    return ExpansionTile(
        title: Text("Scanner sound"),
      subtitle: Text("The sound the scanner makes when it "
          "successfully scans a barcode."),
      children: [
        SwitchListTile(
            title: Text("No sound"),
            value: noSound,
            onChanged: (value) {
              UrovoScanning().setSoundMode(SoundMode.NONE);

              UrovoScanning().getSoundMode().then((value) {
                setState(() {
                  _sound = value;
                });
              });
            }),

        SwitchListTile(
            title: Text("Short sound"),
            value: shortSound,
            onChanged: (value) {
              UrovoScanning().setSoundMode(SoundMode.SHORT);

              UrovoScanning().getSoundMode().then((value) {
                setState(() {
                  _sound = value;
                });
              });
            }),

        SwitchListTile(
            title: Text("Sharp sound"),
            value: sharpSound,
            onChanged: (value) {
              UrovoScanning().setSoundMode(SoundMode.SHARP);

              UrovoScanning().getSoundMode().then((value) {
                setState(() {
                  _sound = value;
                });
              });
            }),
      ],
    );
  }
}