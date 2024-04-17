// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto2/detail_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageDTO2 extends Dto {
  final int id;
  final int number;

  final List<int> operationId;
  final String name;


  final bool isDistributed;

  StageDTO2({
    required this.id,
    required this.number,
    required this.operationId,
    required this.name,

    required this.isDistributed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'operation_id': operationId,
    };
  }

  factory StageDTO2.fromMap(Map<String, dynamic> map) {
    return StageDTO2(
        id: map['id'] as int,
        number: map['number'] as int,
        name: map['name'] as String,
        operationId: (map['operation_id'] as List<dynamic>)
            .map((e) => e as int)
            .toList(),

        isDistributed: map['is_distributed']);
  }

  String toJson() => json.encode(toMap());

  factory StageDTO2.fromJson(String source) =>
      StageDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
