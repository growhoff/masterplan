// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/transfer.dart';

class Operation {
  final int id;
  final String number;
  final String name;
  final String code;
  final bool isready;
  final List<Transfer> transferList;
  final List<int> transferListId;
  final int timepz;
  Operation({
    required this.id,
    required this.number,
    required this.name,
    required this.code,
    required this.isready,
    required this.transferList,
    required this.transferListId,
    required this.timepz,
  });
}
