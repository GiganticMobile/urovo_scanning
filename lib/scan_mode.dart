
///how the scanner should function when it is turned on
///the scanner will automatically turn off (regardless of mode) if the
///time out is reached
enum ScanMode {
  ///The scanner is only in operation as long as the scanning button is pressed
  host(2),

  ///The scanner is only in operation for a short period of time after the
  /// scanning button is pressed
  pulse(0),

  ///The scanner is in operation as soon as the scanning button is
  /// pressed as it only turned off when these buttons are pressed again
  continuous(1);

  const ScanMode(this.id);

  ///
  final int id;
}

/*
PULSE:	Automatic mode. After the scan is triggered, the light is decoded
until the valid barcode is scanned or the laser is turned on and timed out.

CONTINUOUS	Continuous mode. After the scan is triggered, the light is decoded,
and it ends after scanning to a valid barcode or after the laser is turned on,
and then starts the next scan.

HOST	Manual mode. A host command issues the triggering signal,
the scan engine interprets an actual trigger pull as a Level triggering option.
*/
