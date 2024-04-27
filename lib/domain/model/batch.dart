// ignore_for_file: public_member_api_docs, sort_constructors_first

class Batch {
  final int id;
  final String number;
  final String name;
  final int count;
  final String code;
  final String technology;
  final int order;
  final bool isready;
  final int? packageId;
  Batch({
    required this.id,
    required this.number,
    required this.name,
    required this.count,
    required this.code,
    required this.technology,
    required this.order,
    required this.isready,
    required this.packageId,
  });
}
