// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class UnitDTO extends Dto {
  final int id;
  final String name;
  final List<int> areaId;
  UnitDTO({
    required this.id,
    required this.name,
    required this.areaId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'areaId': areaId,
    };
  }

  factory UnitDTO.fromMap(Map<String, dynamic> map) {
    return UnitDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      areaId: (map['area_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UnitDTO.fromJson(String source) => UnitDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
