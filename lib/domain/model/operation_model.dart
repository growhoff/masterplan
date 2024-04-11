import 'package:master_plan/domain/model/transfer_model.dart';

class OperationModel {
  final int id;
  final int number;
  final String name;
  final String code;
  final bool isready;
  final List<TransferModel> transferList;
  final List<int> transferListId;
  OperationModel({
    required this.id,
    required this.number,
    required this.name,
    required this.code,
    required this.isready,
    required this.transferList,
    required this.transferListId,
  });
}