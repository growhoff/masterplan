// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageDTO2 extends Dto {
  final int id;
  final int number;
  final String code;
  final List<int> operationId;
  final String name;
  StageDTO2({
    required this.id,
    required this.number,
    required this.code,
    required this.operationId,
    required this.name
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'code': code,
      'operation_id': operationId,
    };
  }

  factory StageDTO2.fromMap(Map<String, dynamic> map) {
    return StageDTO2(
      id: map['id'] as int,
      number: map['number'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      operationId: (map['operation_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StageDTO2.fromJson(String source) => StageDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
