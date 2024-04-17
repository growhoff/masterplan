import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class DetailDto extends Dto{
  DetailDto(
      {required this.id,
      required this.code,
      required this.technologyNumber,
      required this.planNumber,
      required this.planName});

  final int id;
  final String code;
  final String technologyNumber;
  final String planNumber;
  final String planName;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'technology_number': technologyNumber,
      'plan_number': planNumber,
      'plan_name': planName
    };
  }

  factory DetailDto.fromMap(Map<String, dynamic> map) {
    return DetailDto(
        id: map['id'],
        code: map['code'],
        technologyNumber: map['technology_number'],
        planNumber: map['plan_number'],
        planName: map['plan_name']);
  }
}
