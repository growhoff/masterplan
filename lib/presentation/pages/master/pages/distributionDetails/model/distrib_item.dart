// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';

class DistribItem {
  final int id;
  final String stageNumber;
  final String detailNumber;
  final String operationName;
  final int count;
  final int statusId;
  final String? setMachine;
  final int? setCount;
  final bool isSelected;
  final List<OperatorOperationsDTO> listOperat;
  DistribItem({
    required this.id,
    required this.stageNumber,
    required this.detailNumber,
    required this.operationName,
    required this.count,
    required this.statusId,
    this.setMachine,
    this.setCount,
    required this.isSelected,
    required this.listOperat,
  });

  DistribItem copyWith({
    int? id,
    String? stageNumber,
    String? detailNumber,
    String? operationName,
    int? count,
    int? statusId,
    String? setMachine,
    int? setCount,
    bool? isSelected,
    List<OperatorOperationsDTO>? listOperat,
  }) {
    return DistribItem(
      id: id ?? this.id,
      stageNumber: stageNumber ?? this.stageNumber,
      detailNumber: detailNumber ?? this.detailNumber,
      operationName: operationName ?? this.operationName,
      count: count ?? this.count,
      statusId: statusId ?? this.statusId,
      setMachine: setMachine ?? this.setMachine,
      setCount: setCount ?? this.setCount,
      isSelected: isSelected ?? this.isSelected,
      listOperat: listOperat ?? this.listOperat,
    );
  }
}
