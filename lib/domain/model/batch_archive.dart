import 'package:master_plan/data/repositories/supabase/dto/batch_archive_dto.dart';

class BatchArchive {
  BatchArchive(
      {required this.id,
      required this.number,
      required this.name,
      required this.code,
      required this.technologyNumber,
      required this.companyId});

  final int id;
  final String name;
  final String number;
  final String? code;
  final String technologyNumber;
  final int companyId;

  static final empty = BatchArchive(
    code: '',
    id: 0,
    number: '',
    name: '',
    technologyNumber: '',
    companyId: 0,
  );

  static BatchArchive fromDto(BatchArchiveDto dto) {
    return BatchArchive(
        id: dto.id,
        number: dto.number,
        code: dto.code,
        name: dto.name,
        technologyNumber: dto.technologyNumber,
        companyId: dto.companyId);
  }
}
