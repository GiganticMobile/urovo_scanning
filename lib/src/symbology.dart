

enum CodeType {

  CODE39(
      id: 1,
      title: 'Code39',
      description: 'Bar codes of type Code39.'
  ),
  DISCRETE25(
      id: 1,
      title: "Discrete 2/5",
      description: "Bar codes of type Discrete 2 of 5."
  ),
  MATRIX25(
      id: 1,
      title: 'Matrix 2/5',
      description: 'Bar codes of type Matrix 2 of 5.'
  ),
  INTERLEAVED25(
      id: 1,
      title: 'Interleaved 2/5',
      description: 'Bar codes of type Interleaved 2 of 5.'
  ),
  CODABAR(
      id: 1,
      title: 'Codabar',
      description: 'Bar codes of type Codabar.'
  ),
  CODE93(
      id: 1,
      title: 'Code93',
      description: 'Bar codes of type Code93.'
  ),
  CODE128(
      id: 1,
      title: 'Code128',
      description: 'Bar codes of type Code128.'
  ),
  UPCA(
      id: 1,
      title: 'UPC-A',
      description: 'Bar codes of type UPC-A.'
  ),
  UPCE(
      id: 1,
      title: 'UPC-E',
      description: 'Bar codes of type UPC-E.'
  ),
  UPCE1(
      id: 1,
      title: 'UPC-E1',
      description: 'Bar codes of type UPC-E1.'
  ),
  EAN13(
      id: 1,
      title: 'EAN-13',
      description: 'Bar codes of type EAN-13.'
  ),
  EAN8(
      id: 1,
      title: 'EAN-8',
      description: 'Bar codes of type EAN-8.'
  ),
  MSI(
      id: 1,
      title: 'MSI',
      description: 'Bar codes of type MSI.'
  ),
  GS1_14(
      id: 1,
      title: 'GS1 Databar-14',
      description: 'Bar codes of type GS1 Databar-14.'
  ),
  GS1_LIMIT(
      id: 1,
      title: 'GS1 Databar Limited',
      description: 'Bar codes of type GS1 Databar Limited.'
  ),
  GS1_EXP(
      id: 1,
      title: 'GS1 Databar Expanded',
      description: 'Bar codes of type GS1 Databar Expanded.'
  ),
  CODE49(
      id: 1,
      title: 'Code49',
      description: "Bar codes of type Code49."
  ),
  PDF417(
      id: 1,
      title: 'PDF-417',
      description: 'Bar codes of type PDF-417.'
  ),
  DATAMATRIX(
      id: 1,
      title: 'Datamatrix',
      description: 'Bar codes of type Datamatrix.'
  ),
  MAXICODE(
      id: 1,
      title: 'Maxicode',
      description: 'Bar codes of type Maxicode.'
  ),
  TRIOPTIC(
      id: 1,
      title: 'Trioptic',
      description: 'Bar codes of type Trioptic.'
  ),
  CODE11(
      id: 1,
      title: 'Code11',
      description: 'Bar codes of type Code11.'
  ),
  CODE32(
      id: 1,
      title: 'Code32',
      description: 'Bar codes of type Code32.'
  ),
  MICROPDF417(
      id: 1,
      title: 'MicroPDF417',
      description: 'Bar codes of type Micropdf417.'
  ),
  COMPOSITE(
      id: 1,
      title: 'Composite Code',
      description: 'Bar codes of type composite'
  ),
  QRCODE(
      id: 1,
      title: 'QR Code',
      description: 'Bar codes of type QR.'
  ),
  AZTEC(
      id: 1,
      title: 'Aztec Code',
      description: 'Bar codes of type Aztec.'
  ),
  CHINESE25(
      id: 1,
      title: 'Chinese 2/5.',
      description: 'Bar codes of type Chinese 2 of 5.'
  ),
  POSTAL(
    id: 1,
    title: 'Postal Code',
    description: '',
  );

  const CodeType({
    required this.id,
    required this.title,
    required this.description,
  });

  ///
  final int id;
  ///
  final String title;
  ///
  final String description;

}