// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../data/repositories/supabase/dto/order_dto.dart';

class Order {
  final int id;
  final String number;
  final String? dateReceipt;
  final String? datePlanCompletion;
  final int priority;
  final int statusId;
  final OrderStatus? status;

  Order(
      {required this.id,
      required this.number,
      required this.dateReceipt,
      required this.datePlanCompletion,
      required this.priority,
      required this.statusId,
       this.status});
}
