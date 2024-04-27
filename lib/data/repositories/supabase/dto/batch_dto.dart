// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class BatchDTO extends Dto {
  final int id;
  final String number;
  final String name;
  final int count;
  final String code;
  final String technology;
  final int order;
  final bool isready;
  final int packageId;
  BatchDTO({
    required this.id,
    required this.number,
    required this.name,
    required this.count,
    required this.code,
    required this.technology,
    required this.order,
    required this.isready,
    required this.packageId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'name': name,
      'count': count,
      'code': code,
      'technology': technology,
      'order': order,
      'isready': isready,
      'package_id': packageId,
    };
  }

  factory BatchDTO.fromMap(Map<String, dynamic> map) {
    return BatchDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      name: map['name'] as String,
      count: map['count'] as int,
      code: map['code'] as String,
      technology: map['technology'] as String,
      order: map['order'] as int,
      isready: map['isready'] as bool,
      packageId: map['package_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BatchDTO.fromJson(String source) => BatchDTO.fromMap(json.decode(source) as Map<String, dynamic>);
  }
