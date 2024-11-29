import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class TransferArchiveDto extends Dto {
  final int id;
  final String name;
  final String code;
  final int timeSH;
  final int operationArchiveId;

  TransferArchiveDto({
    required this.id,
    required this.name,
    required this.code,
    required this.timeSH,
    required this.operationArchiveId,
  });


  factory TransferArchiveDto.fromMap(Map<String, dynamic> map) {
    return TransferArchiveDto(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      timeSH: map['time_sh'] as int,
      operationArchiveId: map['operation_archive_id'] as int,
    );
  }
}
