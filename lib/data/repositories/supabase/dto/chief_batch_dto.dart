import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ChiefBatchDTO extends Dto {
  ChiefBatchDTO(
      {required this.id,
      required this.batchId,
      required this.batch,
      this.batchStatusId,
      this.orderId,
      this.order});

  final int id;
  final int batchId;
  final BatchDTO batch;
  final int? batchStatusId;
  final int? orderId;
  final OrderDTO? order;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'batchId': batchId, 'batch': batch};
  }

  factory ChiefBatchDTO.fromMap(Map<String, dynamic> map) {
    return ChiefBatchDTO(
        id: map['id'] as int,
        batchId: map['batch_id'] ?? 0,
        batch: BatchDTO.fromMap(map['z_batch']),
        batchStatusId: map['batch_status_id'] ?? 1,
        orderId: map['order_id'] != null ? map['order_id'] : null,
        order:
            map['z_order'] != null ? OrderDTO.fromMap(map['z_order']) : null);
  }
}
