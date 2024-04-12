// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class MachineDTO extends Dto {
  final int id;
  final int inventoryNumber;
  final String name;
  MachineDTO({
    required this.id,
    required this.inventoryNumber,
    required this.name,
  });

    MachineDTO.init({
     this.id = -1,
     this.inventoryNumber = -1,
     this.name= 'none',
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'inventory_number': inventoryNumber,
      'name': name,
    };
  }

  factory MachineDTO.fromMap(Map<String, dynamic> map) {
    return MachineDTO(
      id: map['id'] as int,
      inventoryNumber: map['inventory_number'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineDTO.fromJson(String source) => MachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
