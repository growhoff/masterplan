// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class OperationDTO2 extends Dto {
  final int id;
  final int number;
  final String name;
  final String code;
  final bool isready;
  final List<int> transferId;
  OperationDTO2({
    required this.id,
    required this.number,
    required this.name,
    required this.code,
    required this.isready,
    required this.transferId,
  });

  // (map['operation_id'] as List<dynamic>).map((e) => e as int).toList(),

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'code': code,
      'isready': isready,
      'transfer_id': transferId,
    };
  }

  factory OperationDTO2.fromMap(Map<String, dynamic> map) {
    return OperationDTO2(
      id: map['id'] as int,
      number: map['number'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      isready: map['isready'] as bool,
      transferId: (map['transfer_id'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OperationDTO2.fromJson(String source) => OperationDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
  }
