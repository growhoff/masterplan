// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class CompanyDTO extends Dto {
  final int id;
  final String name;
  final String code;
  final List<int> unitId;
  CompanyDTO({
    required this.id,
    required this.name,
    required this.code,
    required this.unitId,
  });
    CompanyDTO.init({
    this.id = 0,
    this.name = '0',
    this.code = '0',
    this.unitId = const [],
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'unit_id': unitId,
    };
  }

  factory CompanyDTO.fromMap(Map<String, dynamic> map) {
    return CompanyDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      unitId: (map['unit_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyDTO.fromJson(String source) => CompanyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
