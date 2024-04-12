// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class AreaDTO extends Dto {
  final int id;
  final String name;
  final String number;
  final List<int> machineId;
  AreaDTO({
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

  factory AreaDTO.fromMap(Map<String, dynamic> map) {
    return AreaDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as String,
      machineId: (map['machine_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AreaDTO.fromJson(String source) => AreaDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
