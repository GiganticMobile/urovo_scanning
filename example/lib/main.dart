import 'package:flutter/material.dart';
import 'package:urovo_scanning/urovo_message_interface.g.dart';
import 'package:urovo_scanning/urovo_scanning.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScanScreen(),
    );
  }
}

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Urovo scanning app'),
            actions: [
              IconButton(onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return ListView(children: [
                    ListTile(title: Text("Settings"),),
                    DeviceCompatibleSettingWidget(),
                    PhysicalScanButtonsEnabled(),
                    ScanModeWidget(),
                    SymbologyWidget(),
                    ResetScanner(),
                  ],);
                });

              }, icon: Icon(Icons.settings))
            ],),
          body: Column(children: [
            Expanded(child: Center(child: BarcodeInfoWidget())),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              FilledButton.icon(
                onPressed: () {
                  final _urovoScanningPlugin = UrovoScanning();
                  _urovoScanningPlugin.startScanning(null);
                },
                label: Text("Start"),
                icon: Icon(Icons.barcode_reader),),

              FilledButton.icon(
                onPressed: () {
                  final _urovoScanningPlugin = UrovoScanning();
                  _urovoScanningPlugin.stopScanning();
                },
                label: Text("Stop"),
                icon: Icon(Icons.stop),),
            ],)
          ],),
        ));
  }
}

class DeviceCompatibleSettingWidget extends StatelessWidget {
  DeviceCompatibleSettingWidget({super.key});

  final _urovoScanningPlugin = UrovoScanning();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _urovoScanningPlugin.isDeviceCompatible(),
        builder: (context, value) {
          var result = "unknown";
          if (value.data == true) {
            result = "Device is compatible";
          } else if (value.data == false) {
            result = "Not compatible";
          } else {
            result = "unknown";
          }

          return ListTile(
            title: Text("Is device compatible"),
            subtitle: Text(result),
          );
        });
  }
}

class PhysicalScanButtonsEnabled extends StatelessWidget {
  PhysicalScanButtonsEnabled({super.key});

  final _urovoScanningPlugin = UrovoScanning();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _urovoScanningPlugin.isTriggerEnabled(),
        builder: (context, value) {

          var result = "unknown";
          if (value.data == true) {
            result = "Physical scan buttons enabled";
          } else if (value.data == false) {
            result = "Physical scan buttons disabled";
          } else {
            result = "unknown";
          }

          return ListTile(
            title: Text("Are the physical scanning buttons enabled?"),
            subtitle: Text(result),
            onTap: () {
              final enabled = value.data;
              if (enabled != null) {
                if (!enabled) {
                  _urovoScanningPlugin.enableTrigger();
                } else {
                  _urovoScanningPlugin.disableTrigger();
                }
              }
            },
            trailing: Icon(Icons.arrow_forward_ios),
          );
    });
  }
}

class ScanModeWidget extends StatelessWidget {
  ScanModeWidget({super.key});

  final _urovoScanningPlugin = UrovoScanning();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _urovoScanningPlugin.getTriggerMode(),
        builder: (context, value) {
          final String result;
          if (value.data == null) {
            result = 'unknown';
          } else if (value.data == TriggerMode.HOST) {
            result = 'Host';
          } else if (value.data == TriggerMode.PULSE) {
            result = 'Pulse';
          }  else if (value.data == TriggerMode.CONTINUOUS) {
            result = 'Continuous';
          } else {
            result = 'unknown';
          }

          return ListTile(
            title: Text("Laser scan mode"),
            subtitle: Text(result),
            onTap: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text("Choose scan mode"),
                  actions: [
                    TextButton(onPressed: () {
                      _urovoScanningPlugin.setTriggerMode(TriggerMode.HOST);
                    }, child: Text("Host")),

                    TextButton(onPressed: () {
                      _urovoScanningPlugin.setTriggerMode(TriggerMode.PULSE);
                    }, child: Text("Pulse")),

                    TextButton(onPressed: () {
                      _urovoScanningPlugin.setTriggerMode(TriggerMode.CONTINUOUS);
                    }, child: Text("Continuous")),
                  ],
                );
              });
            },
            trailing: Icon(Icons.arrow_forward_ios),
          );
    });
  }
}

class SymbologyWidget extends StatelessWidget {
  SymbologyWidget({super.key});

  final _urovoScanningPlugin = UrovoScanning();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _urovoScanningPlugin.getSymbology(),
        builder: (context, value) {

          final List<SymbologyCode> codes = value.data ?? [];

          return ExpansionTile(
              title: Text("Code Formats"),
            children: codes.map((code) {
              return CheckboxListTile(
                  value: code.enabled,
                  title: Text(code.title),
                  onChanged: (value) {
                    if (value == true) {
                      _urovoScanningPlugin.enabledSymbology(code);
                    } else {
                      _urovoScanningPlugin.disableSymbology(code);
                    }
                  });
            }).toList(),
          );

        });
  }
}

class ResetScanner extends StatelessWidget {
  const ResetScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Reset scanner"),
      subtitle: Text("Reset scanner to default settings"),
      onTap: () {

      },
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class BarcodeInfoWidget extends StatelessWidget {
  BarcodeInfoWidget({super.key});

  final _urovoScanningPlugin = UrovoScanning();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _urovoScanningPlugin.barcodeStream(),
        builder: (context, value) {

          return SizedBox(
            height: 300,
            child: ListView(children: [
              ListTile(
                title: Text("Barcode"),
                subtitle: Text(value.data?.barcode ?? "unknown"),
              ),
              ListTile(
                title: Text("Barcode in Bytes"),
                subtitle: Text(
                    (value.data?.barcodeBytes ?? []).isNotEmpty
                        ? value.data?.barcodeBytes.toString() ?? 'unknown'
                        : "unknown"),
              ),
              ListTile(
                title: Text("Barcode Length"),
                subtitle: Text(value.data?.length.toString() ?? "unknown"),
              ),
              ListTile(
                title: Text("Barcode type"),
                subtitle: Text(value.data?.type.toString() ?? "unknown"),
              ),
            ],),
          );
    });
  }
}
