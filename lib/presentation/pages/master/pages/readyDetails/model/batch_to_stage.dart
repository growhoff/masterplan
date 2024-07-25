// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';

class BatchToStage {
  final int chiefBatchId;
  final List<ChiefOperationDto> listDto;
  BatchToStage({
    required this.chiefBatchId,
    required this.listDto,
  });
}
