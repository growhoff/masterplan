// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class TransferDTO2 extends Dto {
  final int id;
  final int number;
  final String name;
  final String code;
  final int timepz;
  final int timesh;
  TransferDTO2({
    required this.id,
    required this.number,
    required this.name,
    required this.code,
    required this.timepz,
    required this.timesh,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'code': code,
      'time_pz': timepz,
      'time_sh': timesh,
    };
  }

  factory TransferDTO2.fromMap(Map<String, dynamic> map) {
    return TransferDTO2(
      id: map['id'] as int,
      number: map['number'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      timepz: map['time_pz'] as int,
      timesh: map['time_sh'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferDTO2.fromJson(String source) => TransferDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
  }
