// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class BatchDTO2 extends Dto {
  final int id;
  final int number;
  final String name;
  final int count;
  final int code;
  final int technology;
  final int order;
  final bool isready;
  final List<int> stageId;
  BatchDTO2({
    required this.id,
    required this.number,
    required this.name,
    required this.count,
    required this.code,
    required this.technology,
    required this.order,
    required this.isready,
    required this.stageId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'count': count,
      'code': code,
      'technology': technology,
      'order': order,
      'isready': isready,
      'step_id': stageId,
    };
  }

  factory BatchDTO2.fromMap(Map<String, dynamic> map) {
    return BatchDTO2(
      id: map['id'] as int,
      number: map['number'] as int,
      name: map['name'] as String,
      count: map['count'] as int,
      code: map['code'] as int,
      technology: map['technology'] as int,
      order: map['order'] as int,
      isready: map['isready'] as bool,
      stageId: (map['step_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BatchDTO2.fromJson(String source) => BatchDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
  }
