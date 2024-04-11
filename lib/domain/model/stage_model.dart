import 'package:master_plan/domain/model/operation_model.dart';

class StageModel {
  final int id;
  final int number;
  final String code;
  final List<OperationModel> operationList;
  final List<int> operationListId;

  StageModel({
    required this.id,
    required this.number,
    required this.code,
    required this.operationList,
    required this.operationListId,
  });
}
