class BatchArchive {
  BatchArchive(
      {required this.id,
      required this.number,
      required this.name,
      required this.technologyNumber,
      required this.companyId});

  final int id;
  final String name;
  final String number;
  final String technologyNumber;
  final int companyId;

  static final empty = BatchArchive(
    id: 0,
    number: '',
    name: '',
    technologyNumber: '',
    companyId: 0,
  );
}
