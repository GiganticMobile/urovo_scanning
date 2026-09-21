
///Light configurations settings for the barcode scanner
enum LightMode {

  ///no light or lazer aim assist
  allOff(0),
  ///no light only lazer aim assist
  aimerOnly(1),
  ///only light n lazer aim assist
  illuminationOnly(2),
  ///both light and lazer aim assist
  alternating(3),
  ///
  concurrent(4);

  const LightMode(this.id);

  ///
  final int id;

}
