// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/domain/model/operator_operations.dart';

class DistribItem {
  final String stageNumber;
  final String detailNumber;
  final String operationName;
  final int count;
  final List<OperatorOperations> listOperat;
  final int timeSh;
  final int timePZ;
  final double timeShKal;
  DistribItem({
    required this.stageNumber,
    required this.detailNumber,
    required this.operationName,
    required this.count,
    required this.listOperat,
    required this.timeSh,
    required this.timePZ,
    required this.timeShKal,
  });

  DistribItem copyWith({
    String? stageNumber,
    String? detailNumber,
    String? operationName,
    int? count,
    List<OperatorOperations>? listOperat,
    int? timeSh,
    int? timePZ,
    double? timeShKal,
  }) {
    return DistribItem(
      stageNumber: stageNumber ?? this.stageNumber,
      detailNumber: detailNumber ?? this.detailNumber,
      operationName: operationName ?? this.operationName,
      count: count ?? this.count,
      listOperat: listOperat ?? this.listOperat,
      timeSh: timeSh ?? this.timeSh,
      timePZ: timePZ ?? this.timePZ,
      timeShKal: timeShKal ?? this.timeShKal,
    );
  }
}
