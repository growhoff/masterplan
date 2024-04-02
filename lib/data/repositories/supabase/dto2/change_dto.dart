import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class ChangeDTO2 extends Dto{
  final int id;
  final String name;
  final int number;
  ChangeDTO2({
    required this.id,
    required this.name,
    required this.number,
  });

  ChangeDTO2.init(
    {this.id = -1,
     this.name = '', 
     this.number = -1,
    });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'number': number,
    };
  }

  factory ChangeDTO2.fromMap(Map<String, dynamic> map) {
    return ChangeDTO2(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangeDTO2.fromJson(String source) => ChangeDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
