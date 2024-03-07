import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class RegionDTO extends Dto{
  final int id;
  final String name;
  final int number;
  final int companyId;
  RegionDTO({
    required this.id,
    required this.name,
    required this.number,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'number': number,
      'company_id': companyId,
    };
  }

  factory RegionDTO.fromMap(Map<String, dynamic> map) {
    return RegionDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as int,
      companyId: map['company_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegionDTO.fromJson(String source) => RegionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
