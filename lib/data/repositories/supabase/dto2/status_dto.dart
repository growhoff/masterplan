// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StatusDTO2 extends Dto {
  final int id;
  final String name;
  StatusDTO2({
    required this.id,
    required this.name,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory StatusDTO2.fromMap(Map<String, dynamic> map) {
    return StatusDTO2(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusDTO2.fromJson(String source) => StatusDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
