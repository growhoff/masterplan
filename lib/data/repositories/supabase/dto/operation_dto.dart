// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class OperationDTO extends Dto {
  final int id;
  final String number;
  final String name;
  final String code;
  final bool isready;
  final List<int> transferId;
    final int timepz;
  OperationDTO({
    required this.id,
    required this.number,
    required this.name,
    required this.code,
    required this.isready,
    required this.transferId,
    required this.timepz,
  });

  // (map['operation_id'] as List<dynamic>).map((e) => e as int).toList(),

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'code': code,
      'isready': isready,
      'time_pz': timepz,
      'transfer_id': transferId,
    };
  }

  factory OperationDTO.fromMap(Map<String, dynamic> map) {
    return OperationDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      isready: map['isready'] as bool,
      transferId: (map['transfer_id'] as List<dynamic>).map((e) => e as int).toList(),
      timepz: map['time_pz'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OperationDTO.fromJson(String source) => OperationDTO.fromMap(json.decode(source) as Map<String, dynamic>);
  }
