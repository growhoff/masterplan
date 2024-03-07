import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class EquipmentDTO extends Dto{
  final int id;
  final int inventoryNumber;
  final String name;
  final int regionId;
  final int companyId;
  final int userId;
  EquipmentDTO({
    required this.id,
    required this.inventoryNumber,
    required this.name,
    required this.regionId,
    required this.companyId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'inventory_number': inventoryNumber,
      'name': name,
      'region_id': regionId,
      'company_id': companyId,
      'user_id': userId,
    };
  }

  factory EquipmentDTO.fromMap(Map<String, dynamic> map) {
    return EquipmentDTO(
      id: map['id'] as int,
      inventoryNumber: map['inventory_number'] as int,
      name: map['name'] as String,
      regionId: map['region_id'] as int,
      companyId: map['company_id'] as int,
      userId: map['user_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory EquipmentDTO.fromJson(String source) => EquipmentDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
