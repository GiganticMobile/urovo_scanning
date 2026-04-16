import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_message_interface.g.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

class BarcodeTypesSettings extends StatefulWidget {
  const BarcodeTypesSettings({super.key});

  @override
  State<BarcodeTypesSettings> createState() => _BarcodeTypesSettingsState();
}

class _BarcodeTypesSettingsState extends State<BarcodeTypesSettings> {

  List<SymbologyCode> _codes = [];

  @override
  void initState() {
    super.initState();
    UrovoScanning().getSymbology().then((codes) {
      setState(() {
        _codes = codes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text("Barcode type settings"),
        subtitle: Text("The types of codes the device can or is allowed to scan"),
        children: _codes.map((code) {
          return SwitchListTile(
              title: Text(code.title),
              value: code.enabled,
              onChanged: (value) {
                if (value == true) {
                  UrovoScanning().enabledSymbology(code);
                } else {
                  UrovoScanning().disableSymbology(code);
                }

                UrovoScanning().getSymbology().then((codes) {
                  setState(() {
                    _codes = codes;
                  });
                });
              });
        }).toList(),
    );
  }
}
