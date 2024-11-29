import 'package:master_plan/data/repositories/supabase/dto/batch_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageArchiveDTO extends Dto {
  final int id;
  final String number;
  final String name;
  final BatchArchiveDto? batchArchive;
  final int? batchArchiveId;

  StageArchiveDTO(
      {required this.id,
      required this.number,
      required this.name,
      this.batchArchive,
      this.batchArchiveId});

  factory StageArchiveDTO.fromMap(Map<String, dynamic> map) {
    return StageArchiveDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      name: map['name'] as String,
      batchArchiveId: map['batch_archive_id'],
      batchArchive: map['z_batch_archive'] != null
          ? BatchArchiveDto.fromMap(map['z_batch_archive'])
          : null,
    );
  }
}
