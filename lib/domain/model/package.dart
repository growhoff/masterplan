// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/batch.dart';

class Package {
  final int id;
  final int number;
  final List<Batch> batchList;
  final List<int> batchListId;
  Package({
    required this.id,
    required this.number,
    required this.batchList,
    required this.batchListId,
  });
}
