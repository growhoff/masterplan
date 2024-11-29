import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';

import '../../data/repositories/supabase/dto/batch_dto.dart';
import '../../data/repositories/supabase/dto/order_dto.dart';

class ChiefBatch {
  ChiefBatch(
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

  factory ChiefBatch.fromDto(ChiefBatchDTO dto) {
    return ChiefBatch(
        id: dto.id,
        batchId: dto.batchId,
        batch: dto.batch,
        orderId: dto.orderId,
        order: dto.order,
        batchStatusId: dto.batchStatusId);
  }
}
