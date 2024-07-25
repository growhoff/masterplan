// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class MachineDTO extends Dto {
  final int id;
  final int inventoryNumber;
  final String name;
  final int areaId;
  final bool isActivated;
  final AreaDTO? area;

  MachineDTO(
      {required this.id,
      required this.inventoryNumber,
      required this.name,
      required this.areaId,
      required this.isActivated,
      this.area});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'inventory_number': inventoryNumber,
      'name': name,
      'area_id': areaId,
    };
  }

  factory MachineDTO.fromMap(Map<String, dynamic> map) {
    return MachineDTO(
      id: map['id'] as int,
      inventoryNumber: map['inventory_number'] as int,
      name: map['name'] as String,
      isActivated: map['is_activated'],
      areaId: map['area_id'] as int,
      area: map['z_area'] != null ? AreaDTO.fromMap(map['z_area']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineDTO.fromJson(String source) =>
      MachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
