// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class AreaDTO2 extends Dto {
  final int id;
  final String name;
  final int number;
  final List<int> machineId;
  AreaDTO2({
    required this.id,
    required this.name,
    required this.number,
    required this.machineId,
  });
  


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'number': number,
      'machineId': machineId,
    };
  }

  factory AreaDTO2.fromMap(Map<String, dynamic> map) {
    return AreaDTO2(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as int,
      machineId: (map['machine_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AreaDTO2.fromJson(String source) => AreaDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
