// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class TransferDTO extends Dto {
  final int id;
  final int? number;
  final String name;
  final String code;
  final int timesh;
  final int operationId;
  TransferDTO({
    required this.id,
    this.number,
    required this.name,
    required this.code,
    required this.timesh,
    required this.operationId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'code': code,
      'time_sh': timesh,
      'operation_id': operationId,
    };
  }

  factory TransferDTO.fromMap(Map<String, dynamic> map) {
    return TransferDTO(
      id: map['id'] as int,
      number: map['number'] != null ? map['number'] as int : null,
      name: map['name'] as String,
      code: map['code'] as String,
      timesh: map['time_sh'] as int,
      operationId: map['operation_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferDTO.fromJson(String source) => TransferDTO.fromMap(json.decode(source) as Map<String, dynamic>);
  }
