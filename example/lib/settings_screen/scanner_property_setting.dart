import 'dart:async';

import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

///set scanner configuration values
class ScannerPropertySetting extends StatefulWidget {
  ///
  const ScannerPropertySetting({super.key});

  @override
  State<ScannerPropertySetting> createState() => _ScannerPropertySettingState();
}

class _ScannerPropertySettingState extends State<ScannerPropertySetting> {

  final _propertyIdTextController = TextEditingController();
  final _propertyValueTextController = TextEditingController();

  int propertyId = 0;
  int? propertyValue;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: const Text('Edit Scanner Properties'),
        subtitle: const Text('Edit all properties of the barcode scanner.'),
      children: [
        ListTile(
          title: const Text('Get property value'),
          subtitle: TextField(
            controller: _propertyIdTextController,
            decoration: const InputDecoration(
                label: Text('Property id'),
                hint: Text('Input property id')),
            onSubmitted: (value) {
              final id = int.tryParse(value);
              if (id != null) {
                setState(() {
                  propertyId = id;
                });

                unawaited(UrovoScanning()
                    .getPropertyValue(propertyId: propertyId).then((found) {
                      setState(() {
                        propertyValue = found;
                      });
                }, onError: (_) {
                  setState(() {
                    propertyValue = null;
                  });
                }));
              }
            },
            keyboardType: TextInputType.number,
          ),
        ),
        ListTile(
          title: const Text('Current property value'),
          subtitle: propertyValue != null ? Text(propertyValue.toString())
              : const Text('Not found'),
        ),
        ListTile(
          title: const Text('Set property value'),
          subtitle: TextField(
            controller: _propertyValueTextController,
            decoration: const InputDecoration(
                label: Text('Property value'),
                hint: Text('Input property value')),
            enabled: propertyValue != null,
            onSubmitted: (value) {
              final property = int.tryParse(value);
              if (property != null) {
                setState(() {
                  propertyValue = property;
                });

                unawaited(UrovoScanning()
                    .setPropertyValue(
                    propertyId: propertyId, propertyValue: property)
                    .then((found) {

                }, onError: (_) {
                  setState(() {
                    propertyValue = null;
                  });
                }));
              }
            },
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
