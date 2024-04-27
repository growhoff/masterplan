// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageDTO extends Dto {
  final int id;
  final int number;
  final String name;
  final int areaId;
  final bool isdistributed;
  final int batchId;
  StageDTO({
    required this.id,
    required this.number,
    required this.name,
    required this.areaId,
    required this.isdistributed,
    required this.batchId,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'area_id': areaId,
      'is_distributed': isdistributed,
      'batch_id': batchId,
    };
  }

  factory StageDTO.fromMap(Map<String, dynamic> map) {
    return StageDTO(
      id: map['id'] as int,
      number: map['number'] as int,
      name: map['name'] as String,
      areaId: map['area_id'] as int,
      isdistributed: map['is_distributed'] as bool,
      batchId: map['batch_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDTO.fromJson(String source) => StageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
