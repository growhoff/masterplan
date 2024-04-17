// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageDTO extends Dto {
  final int id;
  final int number;
  final List<int> operationId;
  final String name;
  final int areaId;
  final bool isdistributed;
  StageDTO({
    required this.id,
    required this.number,
    required this.operationId,
    required this.name,
    required this.areaId,
    required this.isdistributed,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'operation_id': operationId,
      'name': name,
      'area_id': areaId,
      'is_distributed': isdistributed,
    };
  }

  factory StageDTO.fromMap(Map<String, dynamic> map) {
    return StageDTO(
      id: map['id'] as int,
      number: map['number'] as int,
      operationId: (map['operation_id'] as List<dynamic>).map((e) => e as int).toList(),
      name: map['name'] as String,
      areaId: map['area_id'] as int,
      isdistributed: map['is_distributed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDTO.fromJson(String source) => StageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
