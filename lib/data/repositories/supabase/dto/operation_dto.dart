// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
// (map['operation_id'] as List<dynamic>).map((e) => e as int).toList(),

class OperationDTO extends Dto {
  final int id;
  final String number;
  final String name;
  final String code;
  final int timepz;
  final int stageId;
  final int? timeSH;
  OperationDTO({
    required this.id,
    required this.number,
    required this.name,
    required this.code,
    required this.timepz,
    required this.stageId,
    this.timeSH
  });

  static final empty = OperationDTO(
    id: 0, 
    number: '', 
    name: '', 
    code: '', 
    timepz: 0, 
    stageId: 0,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'code': code,
      'time_pz': timepz,
      'stage_id': stageId,
    };
  }

  factory OperationDTO.fromMap(Map<String, dynamic> map) {
    return OperationDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      timepz: map['time_pz'] as int,
      stageId: map['stage_id'] as int,
      timeSH: map['time_sh']
    );
  }

  String toJson() => json.encode(toMap());

  factory OperationDTO.fromJson(String source) => OperationDTO.fromMap(json.decode(source) as Map<String, dynamic>);
  }
