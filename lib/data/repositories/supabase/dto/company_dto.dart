// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class CompanyDTO extends Dto {
  final int id;
  final String name;
  final String code;
  CompanyDTO({
    required this.id,
    required this.name,
    required this.code,
  });
    CompanyDTO.init({
    this.id = 0,
    this.name = '0',
    this.code = '0',
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
    };
  }

  factory CompanyDTO.fromMap(Map<String, dynamic> map) {
    return CompanyDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyDTO.fromJson(String source) => CompanyDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
