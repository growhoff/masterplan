// ignore_for_file: public_member_api_docs, sort_constructors_first

class Order {
  final int id;
  final String number;
  final DateTime? dateReceipt;
  final DateTime? datePlanCompletion;
  final int? priority;
  Order({
    required this.id,
    required this.number,
    required this.dateReceipt,
    required this.datePlanCompletion,
    required this.priority
  });
}