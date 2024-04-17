class DetailModel {
  DetailModel(
      {required this.id,
      required this.code,
      required this.technologyNumber,
      required this.planNumber,
      required this.planName});

  final int id;
  final String code;
  final String technologyNumber;
  final String planNumber;
  final String planName;

  static final empty = DetailModel(
      id: 0, code: '', technologyNumber: '', planNumber: '', planName: '');
}
