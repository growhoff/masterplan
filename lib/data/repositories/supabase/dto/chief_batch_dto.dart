import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ChiefBatchDTO extends Dto {
  ChiefBatchDTO({required this.id, required this.batchId, required this.batch, this.batchStatusId});

  final int id;
  final int batchId;
  final BatchDTO batch;
  final int? batchStatusId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'batchId': batchId, 'batch': batch};
  }

  factory ChiefBatchDTO.fromMap(Map<String, dynamic> map) {
    return ChiefBatchDTO(
        id: map['id'] as int,
        batchId: map['batch_id'] ?? 0,
        batch: BatchDTO.fromMap(map['z_batch']),
        batchStatusId: map['batch_status_id'] ?? 1
    );
  }
}
