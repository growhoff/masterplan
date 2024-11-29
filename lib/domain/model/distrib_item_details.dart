// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';

class DistribItemDetails {
  final int id;
  final String stageNumber;
  final String detailNumber;
  final String operationName;
  final int count;
  final int statusId;
  final String? setMachine;
  final int? setCount;
  final int? setOptPart;
  final bool isSelected;
  final List<OperatorOperationsDTO> listOperat;
  final int timeSh;
  final int timePZ;
  final int countTransfer;
  final int orderPriority;
  DistribItemDetails({
    required this.id,
    required this.stageNumber,
    required this.detailNumber,
    required this.operationName,
    required this.count,
    required this.statusId,
    this.setMachine,
    this.setCount,
    this.setOptPart,
    required this.isSelected,
    required this.listOperat,
    required this.timeSh,
    required this.timePZ,
    required this.countTransfer,
    required this.orderPriority,
  });

  DistribItemDetails copyWith({
    int? id,
    String? stageNumber,
    String? detailNumber,
    String? operationName,
    int? count,
    int? statusId,
    String? setMachine,
    int? setCount,
    int? setOptPart,
    bool? isSelected,
    List<OperatorOperationsDTO>? listOperat,
    int? timeSh,
    int? timePZ,
    int? countTransfer,
    int? orderPriority,
  }) {
    return DistribItemDetails(
      id: id ?? this.id,
      stageNumber: stageNumber ?? this.stageNumber,
      detailNumber: detailNumber ?? this.detailNumber,
      operationName: operationName ?? this.operationName,
      count: count ?? this.count,
      statusId: statusId ?? this.statusId,
      setMachine: setMachine ?? this.setMachine,
      setCount: setCount ?? this.setCount,
      setOptPart: setOptPart ?? this.setOptPart,
      isSelected: isSelected ?? this.isSelected,
      listOperat: listOperat ?? this.listOperat,
      timeSh: timeSh ?? this.timeSh,
      timePZ: timePZ ?? this.timePZ,
      countTransfer: countTransfer ?? this.countTransfer,
      orderPriority: orderPriority ?? this.orderPriority,
    );
  }
}
