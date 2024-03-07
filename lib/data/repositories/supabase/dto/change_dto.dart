import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class ChangeDTO extends Dto{
  final int id;
  final String name;
  final int number;
  ChangeDTO({
    required this.id,
    required this.name,
    required this.number,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'number': number,
    };
  }

  factory ChangeDTO.fromMap(Map<String, dynamic> map) {
    return ChangeDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangeDTO.fromJson(String source) => ChangeDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
