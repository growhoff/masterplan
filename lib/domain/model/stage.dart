// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/operation.dart';

class Stage {
  final int id;
  final int number;
  final String code;
  final List<Operation> operationList;
  final List<int> operationListId;
  final String name;
  Stage({
    required this.id,
    required this.number,
    required this.code,
    required this.operationList,
    required this.operationListId,
    required this.name
  });
}
