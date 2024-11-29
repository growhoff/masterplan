// import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_status.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

import '../../../../domain/model/status.dart';

class DistributionStageDto extends Dto {
  DistributionStageDto({
    required this.id,
    required this.chiefBatchId,
    this.chiefBatchDto,
    required this.stageId,
    this.stageDto,
    this.unitDto,
    required this.statusId,
    required this.stageStatus,
    this.unitId,
  });

  final int id;
  final int chiefBatchId;
  final ChiefBatchDTO? chiefBatchDto;
  final int stageId;
  final StageDTO? stageDto;
  final int statusId;
  final int? unitId;
  final UnitDTO? unitDto;
  final StatusDTO? stageStatus;

  factory DistributionStageDto.fromMap(Map<String, dynamic> map) {
    return DistributionStageDto(
        id: map['id'] as int,
        chiefBatchId: map['chief_batch_id'],
        chiefBatchDto: map['z_chief_batch'] != null
            ? ChiefBatchDTO.fromMap(map['z_chief_batch'])
            : null,
        stageId: map['stage_id'],
        stageDto: map['z_stage'] != null
            ? StageDTO.fromMap(
                map['z_stage'],
              )
            : null,
        statusId: map['status_id'],
        unitDto: map['z_unit'] != null ? UnitDTO.fromMap(map['z_unit']) : null,
        stageStatus: map['z_stage_status'] != null
            ? StatusDTO.fromMap(map['z_stage_status'])
            : null,
        unitId: map['unit_id']);
  }
}
