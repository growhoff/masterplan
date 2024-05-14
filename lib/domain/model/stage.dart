// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'batch.dart';

class Stage {
  final int id;
  final String number;
  final String name;
  final int areaId;
  final bool isdistributed;
  final int batchId;
  final Batch? batch;
  final int? operationsQuantity;
  Stage({
    required this.id,
    required this.number,
    required this.name,
    required this.areaId,
    required this.isdistributed,
    required this.batchId,
    this.batch,
    this.operationsQuantity
  });
}
