// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class PositionDTO2 extends Dto {
  final int id;
  final String name;
  PositionDTO2({
    required this.id,
    required this.name,
  });
    PositionDTO2.init({
    this.id = 0,
    this.name = '0',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory PositionDTO2.fromMap(Map<String, dynamic> map) {
    return PositionDTO2(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PositionDTO2.fromJson(String source) => PositionDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
