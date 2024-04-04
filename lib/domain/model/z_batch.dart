// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_stage.dart';

class ZBatch {
  final int id;
  final int number;
  final String name;
  final int count;
  final int code;
  final int technology;
  final int order;
  final bool isready;
  final List<ZStage> stageList;
  final List<int> stageListId;
  ZBatch({
    required this.id,
    required this.number,
    required this.name,
    required this.count,
    required this.code,
    required this.technology,
    required this.order,
    required this.isready,
    required this.stageList,
    required this.stageListId,
  });
}
