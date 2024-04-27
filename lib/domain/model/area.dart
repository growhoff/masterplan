// ignore_for_file: public_member_api_docs, sort_constructors_first

class Area {
  final int id;
  final String name;
  final String number;
  final int unitId;
  final int? machinesQuantity;
  Area({
    required this.id,
    required this.name,
    required this.number,
    required this.unitId,
    this.machinesQuantity
  });
}
