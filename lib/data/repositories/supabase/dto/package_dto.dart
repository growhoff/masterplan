// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
//  areaId: (map['area_id'] as List<dynamic>).map((e) => e as int).toList(),
class PackageDTO extends Dto {
  final int id;
  final int number;
  PackageDTO({
    required this.id,
    required this.number,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
    };
  }

  factory PackageDTO.fromMap(Map<String, dynamic> map) {
    return PackageDTO(
      id: map['id'] as int,
      number: map['number'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PackageDTO.fromJson(String source) => PackageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
