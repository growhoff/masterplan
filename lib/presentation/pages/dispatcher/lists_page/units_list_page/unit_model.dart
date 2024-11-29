class UnitModel {
  UnitModel(
      {required this.unitId,
      required this.unitName,
      required this.unitNumber,
      required this.chiefFIO,
      required this.chiefId});

  final int chiefId;
  final int unitId;
  final String unitName;
  final String unitNumber;
  final String chiefFIO;

  int areasQuantity = 0;
  int operatorsQuantity = 0;
  int machinesQuantity = 0;
  int supportStaffQuantity = 0;
}
