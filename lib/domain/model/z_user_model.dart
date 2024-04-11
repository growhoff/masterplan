import 'package:master_plan/domain/model/position.dart';

class ZUserModel {
  final int id;
  final String fio;
  final int? positionId;
  final int companyId;
  final int? unitId;
  final int? areaId;
  final String? photo;
  final PositionModel? positionModel;

  ZUserModel(
      {required this.id,
      required this.fio,
      required this.positionId,
      required this.companyId,
      required this.unitId,
      required this.areaId,
      required this.photo,
      required this.positionModel});

  static final empty = ZUserModel(
      id: 0,
      fio: '',
      positionId: 0,
      companyId: 0,
      unitId: 0,
      areaId: 0,
      photo: '',
      positionModel: PositionModel(id: 0, name: ''));
}