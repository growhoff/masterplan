import 'package:master_plan/data/repositories/supabase/dto/stage_archive_dto.dart';

import 'batch_archive.dart';

class StageArchive {
  final int id;
  final String number;
  final String name;
  final BatchArchive? batchArchive;
  final int? batchArchiveId;

  StageArchive(
      {required this.id,
      required this.number,
      required this.name,
      this.batchArchive,
      this.batchArchiveId});

  factory StageArchive.fromDto(StageArchiveDTO dto) {
    return StageArchive(
        id: dto.id,
        number: dto.number,
        name: dto.name,
        batchArchiveId: dto.batchArchiveId,
        batchArchive: BatchArchive(
            id: dto.batchArchive?.id ?? 0,
            number: dto.batchArchive?.number ?? '',
            name: dto.batchArchive?.name ?? '',
            code: dto.batchArchive?.code,
            technologyNumber: dto.batchArchive?.technologyNumber ?? '',
            companyId: dto.batchArchive?.companyId ?? 0));
  }
}
