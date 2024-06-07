// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/domain/model/operator_operations.dart';

class ItemOperReady {
  final List<OperatorOperations> list;
  final List<int> listId;
  final int idPath;
  ItemOperReady({
    required this.list,
    required this.listId,
    required this.idPath,
  });
}
