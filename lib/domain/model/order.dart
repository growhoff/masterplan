// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../data/repositories/supabase/dto/order_dto.dart';

class Order {
  final int id;
  final String number;
  final String? dateReceipt;
  final String? requiredCompletionDate;
  final String? calculatedCompletionDate;
  final String? actualCompletionDate;
  final String? customer;
  final int priority;
  final int statusId;
  final OrderStatus? status;

  Order(
      {required this.id,
      this.status,
        this.customer,
      required this.number,
      this.dateReceipt,
      this.requiredCompletionDate,
      this.calculatedCompletionDate,
      this.actualCompletionDate,
      required this.priority,
      required this.statusId});
}
