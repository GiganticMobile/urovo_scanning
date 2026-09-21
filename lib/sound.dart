
///the sound the scanner makes when it successfully scans a barcode
enum Sound {

  ///no sound
  none(0),

  ///short sound
  short(1),

  ///sharp sound
  sharp(2);

  const Sound(this.id);

  ///
  final int id;

}
