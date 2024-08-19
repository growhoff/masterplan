// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

//  areaId: (map['area_id'] as List<dynamic>).map((e) => e as int).toList(),
class OrderDTO extends Dto {
  final int id;
  final String number;
  final String? dateReceipt;
  final String? requiredCompletionDate;
  final String? calculatedCompletionDate;
  final String? actualCompletionDate;
  final int priority;
  final int statusId;
  final String? customer;
  final OrderStatus? status;

  OrderDTO(
      {required this.id,
      this.status,
      required this.number,
        this.customer,
       this.dateReceipt,
       this.requiredCompletionDate,
       this.calculatedCompletionDate,
       this.actualCompletionDate,
      required this.priority,
      required this.statusId});

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
        requiredCompletionDate: map['required_completion_date'],
        calculatedCompletionDate: map['calculated_completion_date'],
        actualCompletionDate: map['actual_completion_date'],
        priority: map['priority'],
        customer: map['customer'],
        status: map['z_order_status'] != null
            ? OrderStatus.fromMap(map['z_order_status'])
            : null,
        statusId: map['order_status_id']);
  }

  String toJson() => json.encode(toMap());

  factory OrderDTO.fromJson(String source) =>
      OrderDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OrderStatus {
  OrderStatus({required this.id, required this.name});

  final int id;
  final String name;

  factory OrderStatus.fromMap(Map<String, dynamic> map) {
    return OrderStatus(
      id: map['id'],
      name: map['name'],
    );
  }
}
