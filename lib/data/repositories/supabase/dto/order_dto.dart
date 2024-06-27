// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
//  areaId: (map['area_id'] as List<dynamic>).map((e) => e as int).toList(),
class OrderDTO extends Dto {
  final int id;
  final String number;
  final String? dateReceipt;
  final String? datePlanCompletion;
  final int priority;
  final bool isFormed;
  OrderDTO({
    required this.id,
    required this.number,
    required this.dateReceipt,
    required this.datePlanCompletion,
    required this.priority,
    required this.isFormed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
    };
  }

  factory OrderDTO.fromMap(Map<String, dynamic> map) {
    return OrderDTO(
      id: map['id'] as int,
      number: map['number'] as String,
      dateReceipt: map['date_receipt'],
      datePlanCompletion: map['date_plan_completion'],
      priority: map['priority'],
      isFormed: map['is_formed']
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDTO.fromJson(String source) => OrderDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
