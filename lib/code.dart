
///this represents a barcode
class Code {

  ///
  Code({
    required this.id,
    required this.type,
    required this.supported,
    required bool enabled
  }) : _enabled = enabled;

  ///the format id
  final int id;

  ///the format type of the barcode
  final String type;

  ///is the barcode supported by the scanner
  final bool supported;

  final bool _enabled;

///is the scanner allowed to scan this barcode
  bool isEnabled() {
    if (!supported) {
      //if not supported when it cannot be enabled
      return false;
    }
    return _enabled;
  }

}
