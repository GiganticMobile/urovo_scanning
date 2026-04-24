# urovo_scanning

Urovo scanning is a plugin that allows flutter apps to interact with laser scanning functionality
of urovo devices.

## Platform Support

This plugin only works with Urovo devices (https://en.urovo.com)

## Usage

Import `import 'package:urovo_scanning/urovo_scanning.dart';`

Examples:

- isDeviceCompatible
Check if the device can use the plugin. As in order to work the device must be a urovo
scanner.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  final isCompatible = await UrovoScanning().isDeviceCompatible();

  if (isCompatible == true) {
    ///device is compatible with plugin (so will work)
  } else {
    ///device not compatible with plugin (so will not work)
  }

```
- barcodeStringSteam
Stream of the barcodes in the form of text.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  UrovoScanning().barcodeStringSteam().listen((barcode) {
    
  });
```

- barcodeBytesStream
Stream of barcodes in the form of bytes list
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  UrovoScanning().barcodeBytesStream().listen((barcode) {
    
  });
```
- barcodeStream
Stream of barcodes. Each barcode item contains all the information
the scanner could get after scanning the barcode.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  UrovoScanning().barcodeStream().listen((barcode) {
    
    ///the barcode in the form of bytes
    barcode.bytes;

    ///the barcode in the form of a string
    barcode.barcodeAsString;

    ///the length of the byte list
    barcode.length;
    
    ///the barcode version such as QR code
    barcode.code;
    
    ///the type code of the barcode
    barcode.type;
  });
```

- startScanning
Start scanning programmatically. When started the scanner will automatically
stop if the scanner's time out is reached.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  TextButton(
    onPressed: () async {
      await UrovoScanning().startScanning();
    },
    child: const Text('Start')
  )
```
- stopScanning
Stop scanning programmatically.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  TextButton(
    onPressed: () async {
      await UrovoScanning().stopScanning();
    },
    child: const Text('Stop')
  )
```

- get and set time out
Read and update the maximum amount of time the scanner can stay on for
without successfully scanning a barcode. If the scanner does successfully
scan a barcode it will automatically turn off.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  //get time out
  final timeout = await UrovoScanning().getTimeout();

  final newTimeOut = 5.5;
  await UrovoScanning().setTimeout(newTimeOut);

```

- get and set sound
read and update the sound mode of the scanner. If the scanner successfully 
scans a barcode the scanner will make a sound based on the sound mode option.
The option are none (no sound), short and sharp
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  final soundMode = await UrovoScanning().getSoundMode();
  
  if (soundMode == Sound.none) {
    //no sound on succeful scan
  }

  if (soundMode == Sound.short) {
    //short sound on succeful scan
  }

  if (soundMode == Sound.short) {
    //short sound on succeful scan
  }

  await UrovoScanning().setSoundMode(Sound.none);

```
- enable and disable vibration
read, enable and disable vibration of the scanner. If the scanner 
successfully scans a barcode the scanner will vibrate if enabled.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  final isVibrationEnabled = await UrovoScanning().isVibrationEnabled();

  //enable vibration
  await UrovoScanning().enableVibration(enable: true);
  
  //diable vibration
  await UrovoScanning().enableVibration(enable: false);
```

- enable and disable scanner trigger
read, enable and disable the scanners the device's scan buttons.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  final scanButtonEnabled = await UrovoScanning().isTriggerEnabled();

  //enable trigger 
  await UrovoScanning().enableTrigger(enable: true);

  //diable trigger 
  await UrovoScanning().enableTrigger(enable: false);
```

- get and set scan mode
read and update scan mode of the scanner. The options are.
host: only turns on as long as the scan button is pressed.
pulse: once turned on the scanner stays on for a set amount of time.
continuous: once turned on the scanner will stay on until the scan
buttons are pressed again (i.e press the scan button once to turn on then
once again to turn off).
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  final scanMode = await UrovoScanning().getScanMode();

  await UrovoScanning().setScanMode(ScanMode.host);
```

getCodes
- get code options
Get the types of barcodes that the scanner can scan.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  //get a list of all the codes that are available
  final codes = await UrovoScanning().getCodes();
  
  //get a list of all the codes that the device can support
  final supported = await UrovoScanning().getSupportedCodes();
  
  //get a list of all the codes that the device is allowed to scan
  final enabled = await UrovoScanning().getEnabledCodes();
  
  final codeId = 1;
  final code = await UrovoScanning().getCode(codeId)
  if (code == null) {
    // could not find code
  } else {
    //id of the code type
    code.id;
    
    //the type of code
    code.type;

    //if true the device is able to scan this type of barcode
    code.supported;

    //if true the device is allowed to scan this type of barcode
    code.isEnabled();
  }
```

- enable and disable code
Choose which types of barcodes the scanner is allowed to scan.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  final code = Code(id: 1, type: "QR", supported: true, enabled: true);
  
  //enable code
  await UrovoScanning().enabledCode(code: code, enable: true);
  
  //disable code
  await UrovoScanning().enabledCode(code: code, enable: false);
  
  //enable all codes that are supported by the device
  await UrovoScanning().enableAllCodes(true);
  
  //disable all codes that are supported by the device
  await UrovoScanning().enableAllCodes(false);
  
```

- reset scanner
Reset the scanner to it's default settings.
```dart
  import 'package:urovo_scanning/urovo_scanning.dart';

  await UrovoScanning().resetScanner();
```

## Learn more
This project is based on Urovo software to learn more go to. 
https://en.urovo.com/developer/android/device/ScanManager.html

To learn more about Urovo scanners go to.
https://en.urovo.com

## Maintained by
Gigantic tickets. https://www.gigantic.com

