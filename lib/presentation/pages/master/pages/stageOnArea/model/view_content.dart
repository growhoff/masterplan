// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/batch.dart';

class ViewContent {
  final String stageNumber;
  final String batchNumber;
  final String batchName;
  final int precentPerfect;
  final int chiefBatchId;
  final int stageId;
  final Batch batch;
  String status;
  ViewContent({
    required this.stageNumber,
    required this.batchNumber,
    required this.batchName,
    required this.precentPerfect,
    required this.chiefBatchId,
    required this.stageId,
    required this.batch,
    this.status = '',
  });
}
