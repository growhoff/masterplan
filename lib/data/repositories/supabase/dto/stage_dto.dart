// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageDTO extends Dto {
  final int id;
  final int number;
  final String code;
  final List<int> operationId;
  final String name;
  StageDTO({
    required this.id,
    required this.number,
    required this.code,
    required this.operationId,
    required this.name,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'code': code,
      'operation_id': operationId,
      'name': name,
    };
  }

  factory StageDTO.fromMap(Map<String, dynamic> map) {
    return StageDTO(
      id: map['id'] as int,
      number: map['number'] as int,
      code: map['code'] as String,
      operationId: (map['operation_id'] as List<dynamic>).map((e) => e as int).toList(),
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDTO.fromJson(String source) => StageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
