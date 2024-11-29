// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';

import 'batch.dart';

class Stage {
  final int id;
  final String number;
  final String name;
  final int? areaId;
  final int? batchId;
  final Batch? batch;
  final int? batchArchiveId;

  Stage({
    required this.id,
    required this.number,
    required this.name,
    this.areaId,

     this.batchId,
    this.batch,
    this.batchArchiveId,
  });

  factory Stage.fromDto(StageDTO dto) {
    return Stage(
        id: dto.id,
        number: dto.number,
        name: dto.name,
        areaId: dto.areaId,
        batchId: dto.batchId,
   );
  }
}
