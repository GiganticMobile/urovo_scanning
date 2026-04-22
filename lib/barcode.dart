import 'dart:typed_data';

///All the information related to a scanned barcode
class Barcode {

  ///
  Barcode({
    required Uint8List? bytes,
    required String? barcodeAsString,
    required int? length,
    required String? code,
    required int? type,
  }) : bytes = bytes ?? Uint8List.fromList([]),
      barcodeAsString = barcodeAsString ?? '',
      length = length ?? 0,
      code = code ?? '',
      type = type ?? 0;

  ///The barcode in the form of a byte array
  final Uint8List bytes;
  ///the barcode in the form of a string
  final String barcodeAsString;
  ///the length of the barcode byte array
  final int length;
  ///the barcode version such as QR code
  final String code;
  ///the type id of the barcode
  final int type;

}
