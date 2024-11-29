// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/operator_operations.dart';

class ItemOperation {
  final OperatorOperations operation;
  final int status;
  ItemOperation({
    required this.operation,
    required this.status,
  });


  ItemOperation copyWith({
    OperatorOperations? operation,
    int? status,
  }) {
    return ItemOperation(
      operation: operation ?? this.operation,
      status: status ?? this.status,
    );
  }
}
