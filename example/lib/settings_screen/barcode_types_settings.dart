import 'dart:async';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/Code.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///Enable and disable barcode types
class BarcodeTypesSettings extends StatefulWidget {
  ///
  const BarcodeTypesSettings({super.key});

  @override
  State<BarcodeTypesSettings> createState() => _BarcodeTypesSettingsState();
}

class _BarcodeTypesSettingsState extends State<BarcodeTypesSettings> {

  List<Code> _codes = [];

  @override
  void initState() {
    super.initState();
    unawaited(
        UrovoScanning().getCodes().then((codes,) {
          if (mounted) {
            setState(() {
              _codes = codes;
            });
          }
        }, onError: (error) {
          //catch error but do nothing
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: const Text('Barcode type settings'),
        subtitle:
        const Text('The types of codes the device can or is allowed to scan'),
        children: _codes.map((code) {
          return SwitchListTile(
              title: Text(code.type),
              subtitle: code.supported ?
              const Text('Supported') : const Text('Not supported'),
              value: code.isEnabled(),
              onChanged: (value) async {
                await UrovoScanning().enabledCode(code: code, enable: value);

                final codes = await UrovoScanning().getCodes();

                if (mounted) {
                  setState(() {
                    _codes = codes;
                  });
                }
              });
        }).toList(),
    );
  }
}

///Enable and disable all barcode type universally
class UniversalBarcodeTypeSettings extends StatefulWidget {
  ///
  const UniversalBarcodeTypeSettings({super.key});

  @override
  State<UniversalBarcodeTypeSettings> createState() => _UniversalBarcodeTypeSettingsState();
}

class _UniversalBarcodeTypeSettingsState extends State<UniversalBarcodeTypeSettings> {

  bool? _allTypesEnabled;

  @override
  void initState() {
    super.initState();
    unawaited(_setup());
  }

  Future<void> _setup() async {
    List<Code> codes;
    try {
      codes = await UrovoScanning().getSupportedCodes();
    } on Exception {
      codes = [];
    }

    //if at least 1 code is enabled then it cannot be all disabled
    final enabledCode = codes.where((code) => code.isEnabled()).firstOrNull;

    //if at least 1 code is disabled then it cannot be all enabled
    final disabledCode = codes.where((code) => !code.isEnabled()).firstOrNull;

    if (mounted) {
      setState(() {
        if (enabledCode == null) {
          //no enabled codes so all disabled
          _allTypesEnabled = false;
        } else if (disabledCode == null) {
          //no disabled codes so all enabled
          _allTypesEnabled = true;
        } else {
          //mix of both enabled and disabled types
          _allTypesEnabled = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: const Text('Universal Barcode type setting'),
        subtitle: const Text('Enable or disable all barcode types'),
        value: _allTypesEnabled,
        tristate: true,
        onChanged: (value) {
          if (value != null) {
            try {
              if (value) {
                unawaited(UrovoScanning().enableAllCodes(enable: true));
              } else {
                unawaited(UrovoScanning().enableAllCodes(enable: false));
              }
              unawaited(_setup());
            } on Exception {
              //catch but do nothing
            }
          } else {
            setState(() {
              _allTypesEnabled = null;
            });
          }
        });
  }
}
