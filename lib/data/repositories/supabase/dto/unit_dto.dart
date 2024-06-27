// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class UnitDTO extends Dto {
  final int id;
  final String? name;
  final String? number;
  final int companyId;
  UnitDTO({
    required this.id,
    this.name,
    this.number,
    required this.companyId,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'company_id': companyId,
    };
  }

  factory UnitDTO.fromMap(Map<String, dynamic> map) {
    return UnitDTO(
      id: map['id'] as int,
      name: map['name'] ?? '',
      companyId: map['company_id'] as int,
      number: map['number'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory UnitDTO.fromJson(String source) => UnitDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
