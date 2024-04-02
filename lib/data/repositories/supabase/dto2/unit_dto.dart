// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class UnitDTO2 extends Dto {
  final int id;
  final String name;
  final List<AreaDTO2> areaId;
  UnitDTO2({
    required this.id,
    required this.name,
    required this.areaId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'areaId': areaId.map((x) => x.toMap()).toList(),
    };
  }

  factory UnitDTO2.fromMap(Map<String, dynamic> map) {
    return UnitDTO2(
      id: map['id'] as int,
      name: map['name'] as String,
      areaId: List<AreaDTO2>.from((map['areaId'] as List<int>).map<AreaDTO2>((x) => AreaDTO2.fromMap(x as Map<String,dynamic>),),),
      // (map['area_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UnitDTO2.fromJson(String source) => UnitDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
