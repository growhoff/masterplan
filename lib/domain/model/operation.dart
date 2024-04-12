// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/transfer.dart';

class Operation {
  final int id;
  final int number;
  final String name;
  final String code;
  final bool isready;
  final List<Transfer> transferList;
  final List<int> transferListId;
  Operation({
    required this.id,
    required this.number,
    required this.name,
    required this.code,
    required this.isready,
    required this.transferList,
    required this.transferListId,
  });
}
