import 'package:flutter/material.dart';
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
                    ListTile(
                      title: Text("rest of settings"),
                      subtitle: Text("ETC"),
                    ),
                  ],);
                });

              }, icon: Icon(Icons.settings))
            ],),
          body: Column(children: [
            Expanded(child: Center(child: BarcodeInfoWidget())),
            FilledButton.icon(
              onPressed: () {},
              label: Text("Scan"),
              icon: Icon(Icons.barcode_reader),)
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
