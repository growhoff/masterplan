// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/view_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class TypeMachineDTO extends Dto {
  final int id;
  final int number;
  final String name;
  final int viewMachineId;
  final ViewMachineDTO? viewMachine;

  TypeMachineDTO({
    required this.id,
    required this.number,
    required this.name,
    required this.viewMachineId,
    this.viewMachine,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'view_machine_id': viewMachineId,
    };
  }

  factory TypeMachineDTO.fromMap(Map<String, dynamic> map) {
    return TypeMachineDTO(
      id: map['id'] as int,
      number: map['number'] as int,
      name: map['name'] as String,
      viewMachineId: map['view_machine_id'] as int,
      viewMachine: map['z_view_machine'] != null ? ViewMachineDTO.fromMap(map['z_view_machine'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeMachineDTO.fromJson(String source) => TypeMachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
