import 'package:master_plan/data/repositories/supabase/dto/stage_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class OperationArchiveDto extends Dto {
  final int id;
  final String number;
  final String name;
  final String code;
  final int timepz;
  final int stageArchiveId;
  final StageArchiveDTO? stageArchiveDTO;
  final int timeSH;

  OperationArchiveDto(
      {required this.id,
      required this.number,
      required this.name,
      required this.code,
      required this.timepz,
      required this.stageArchiveId,
      this.stageArchiveDTO,
      required this.timeSH});

  factory OperationArchiveDto.fromMap(Map<String, dynamic> map) {
    return OperationArchiveDto(
        id: map['id'] as int,
        number: map['number'] as String,
        name: map['name'] as String,
        code: map['code'] as String,
        timepz: map['time_pz'] as int,
        stageArchiveId: map['stage_archive_id'],
        timeSH: map['time_sh'],
        stageArchiveDTO: map['z_stage_archive'] != null
            ? StageArchiveDTO.fromMap(map['z_stage_archive'])
            : null);
  }
}
