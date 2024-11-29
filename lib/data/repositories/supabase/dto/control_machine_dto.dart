// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ControlMachineDTO extends Dto {
  final int id;
  final int number;
  final String name;

  ControlMachineDTO({
    required this.id,
    required this.number,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
    };
  }

  factory ControlMachineDTO.fromMap(Map<String, dynamic> map) {
    return ControlMachineDTO(
      id: map['id'] as int,
      number: map['number'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ControlMachineDTO.fromJson(String source) => ControlMachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
