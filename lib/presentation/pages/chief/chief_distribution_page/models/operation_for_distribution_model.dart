import '../../../../../domain/model/area.dart';
import '../../../../../domain/model/chief_distribution_operations_model.dart';

class OperationForDistributionModel {
  OperationForDistributionModel(
      {required this.chiefDistributionOperation, required this.oldQuantity});

  final ChiefDistributionOperation chiefDistributionOperation;

  final int oldQuantity;
  int quantity = 0;

  Area area = Area.empty;
}
