import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';

class DistributionOperationModel {
  DistributionOperationModel(
      {required this.operationName,
      required this.operationNumber,
      required this.timeSH,
      required this.timePZ,
      required this.timeSHC,
      required this.chiefDistributionOperation,
      });


  final ChiefDistributionOperation chiefDistributionOperation;
  final String operationNumber;
  final String operationName;
  final int timePZ;
  final int timeSH;
  final String timeSHC;
  int availableQuantity = 0;
  int totalQuantity = 0;
}
