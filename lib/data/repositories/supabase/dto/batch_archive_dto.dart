import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class BatchArchiveDto extends Dto{
  BatchArchiveDto(
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

  factory BatchArchiveDto.fromMap(Map<String, dynamic> map) {
    return BatchArchiveDto(
        id: map['id'] as int,
        name: map['name'] as String,
        code: map['code'],
        number: map['number'] as String,
        technologyNumber: map['technology_number'],
        companyId: map['company_id']);
  }
}
