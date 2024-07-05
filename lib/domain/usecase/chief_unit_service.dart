class ChiefUnitService {
  int? unitId;

  static final ChiefUnitService instance = ChiefUnitService._internal();

  ChiefUnitService._internal();

  factory ChiefUnitService(int unitId) {
    instance.unitId = unitId;

    return instance;
  }
}
