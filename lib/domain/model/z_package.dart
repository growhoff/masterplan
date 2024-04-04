// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_batch.dart';

class ZPackage {
  final int id;
  final int number;
  final List<ZBatch> batchList;
  final List<int> batchListId;
  ZPackage({
    required this.id,
    required this.number,
    required this.batchList,
    required this.batchListId,
  });
}
