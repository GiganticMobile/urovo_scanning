import 'package:flutter/material.dart';

///on screen button to start and stop scanning
class ScanButton extends StatefulWidget {
  ///
  const ScanButton({
    required this.onStart,
    required this.onStop,
    super.key});

  ///
  final VoidCallback? onStart;
  ///
  final VoidCallback? onStop;

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {

  bool startScan = true;

  @override
  Widget build(BuildContext context) {

    late final String title;
    late final IconData icon;
    late final VoidCallback? onPressed;

    //is button enabled
    final disabled = widget.onStart == null || widget.onStop == null;
    if (disabled) {
      title = 'Disabled';
      icon = Icons.do_disturb;
      onPressed = null;
    } else {
      if (startScan) {
        title = 'Scan';
        icon = Icons.barcode_reader;
        onPressed = widget.onStart;
      } else {
        title = 'Stop';
        icon = Icons.stop;
        onPressed = widget.onStop;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: FilledButton.icon(
        onPressed: !disabled ? () {
          setState(() {
            //switch between start and stop
            startScan = !startScan;
          });
          onPressed?.call();
        } : null,
        icon: Icon(icon, size: 50,),
        label: Text(title,
          textScaler: TextScaler.noScaling,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        style: FilledButton.styleFrom(fixedSize: const Size(250, 80)),
      ),
    );
  }
}
