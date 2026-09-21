import 'package:flutter/material.dart';
import 'package:urovo_scanning_example/settings_screen/barcode_types_settings.dart';
import 'package:urovo_scanning_example/settings_screen/device_compatible_view.dart';
import 'package:urovo_scanning_example/settings_screen/reset_scanner_settings.dart';
import 'package:urovo_scanning_example/settings_screen/scan_buttons_settings_widget.dart';
import 'package:urovo_scanning_example/settings_screen/scan_mode_settings_widget.dart';
import 'package:urovo_scanning_example/settings_screen/scanner_light_mode_settings.dart';
import 'package:urovo_scanning_example/settings_screen/scanner_property_setting.dart';
import 'package:urovo_scanning_example/settings_screen/scanner_sound_settings.dart';
import 'package:urovo_scanning_example/settings_screen/scanner_timeout_settings.dart';
import 'package:urovo_scanning_example/settings_screen/scanner_vibrate_setting.dart';

///scanner settings screen
class SettingsScreen extends StatelessWidget {
  ///
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(slivers: [
              const SliverAppBar(
                title: Text('Settings'),
              ),
              SliverList.list(children: const [
                DeviceCompatibleView(),
                ScannerTimeoutSettings(),
                ScannerSoundSettings(),
                ScannerVibrateSetting(),
                ScanModeSettingsWidget(),
                ScanButtonsSettingsWidget(),
                UniversalBarcodeTypeSettings(),
                BarcodeTypesSettings(),
                ScannerLightModeSettings(),
                ScannerPropertySetting(),
                ResetScannerSettings(),
              ])
            ])
        )
    );
  }
}
