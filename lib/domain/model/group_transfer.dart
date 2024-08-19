// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/transfer.dart';

class GroupTransfer {
  final int operId;
  final List<Transfer> listTransfer;
  GroupTransfer({
    required this.operId,
    required this.listTransfer,
  });
}
