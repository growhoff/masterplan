// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';

class StageView {
  final int stageId;
  final List<OperatorOperationsDTO> listOper;
  StageView({
    required this.stageId,
    required this.listOper,
  });

}
