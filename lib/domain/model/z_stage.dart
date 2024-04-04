// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_operation.dart';

class ZStage {
  final int id;
  final int number;
  final String code;
  final List<ZOperation> operationList;
  final List<int> operationListId;
  ZStage({
    required this.id,
    required this.number,
    required this.code,
    required this.operationList,
    required this.operationListId,
  });
}
