// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StatusMachineDTO extends Dto {
  final int id;
  final String name;
  StatusMachineDTO({
    required this.id,
    required this.name,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory StatusMachineDTO.fromMap(Map<String, dynamic> map) {
    return StatusMachineDTO(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusMachineDTO.fromJson(String source) => StatusMachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
