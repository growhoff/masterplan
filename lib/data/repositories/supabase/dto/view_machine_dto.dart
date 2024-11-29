// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ViewMachineDTO extends Dto {
  final int id;
  final int number;
  final String name;

  ViewMachineDTO({
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

  factory ViewMachineDTO.fromMap(Map<String, dynamic> map) {
    return ViewMachineDTO(
      id: map['id'] as int,
      number: map['number'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ViewMachineDTO.fromJson(String source) => ViewMachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
