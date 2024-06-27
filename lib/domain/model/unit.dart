// ignore_for_file: public_member_api_docs, sort_constructors_first

class Unit {
  final int id;
  final String? name;
  final String? number;
  final int companyId;

  Unit({
    required this.id,
    this.name,
    this.number,
    required this.companyId,
  });

  static final empty = Unit(id: 0, companyId: 0);
}
