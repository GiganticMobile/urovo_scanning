import 'dart:typed_data';

import 'package:flutter/material.dart';

///displays the image taken when the app successfully scans the barcode
class BarcodeImageWidget extends StatelessWidget {
  ///
  const BarcodeImageWidget({required this.imageBytes, super.key});

  ///image in the form of byte list
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {

    const height = 150.0;
    const width = double.infinity;

    if (imageBytes.isEmpty) {
      return Container(
        height: height,
        width: width,
        color: Theme.of(context).colorScheme.surfaceContainer,
      );
    } else {
      return Image.memory(
        imageBytes,
        height: height,
        width: width,
        fit: BoxFit.contain,
      );
    }
  }
}
