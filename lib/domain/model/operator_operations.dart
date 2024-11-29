// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/transfer.dart';
import 'package:master_plan/domain/model/unit.dart';
import 'package:master_plan/domain/model/user.dart';

import 'distribution_stage.dart';
import 'order.dart';

class OperatorOperations {
  final int id;
  final int timeplan;
  final bool? pause;
  final int timeFirstStart;
  final Status status;
  final Batch batch;
  final StageDTO stage;
  final OperationDTO operation;
  final AreaDTO area;
  final Machine? machine;
  final int? order;
  final int? distributionStageId;
  final int? optimalPart;

  final int? timestart;
  final int? timestop;
  final int? timeworking;
  final User? user;
  final int? chiefBatchId;
  final int? chiefOperationId;
  final bool? modific;
  final String? comment;

  final DistributionStage? distributionStage;
  final List<Transfer>? listTransfer;

  OperatorOperations({
    required this.id,
    required this.timeplan,
    this.pause,
    required this.timeFirstStart,
    required this.status,
    required this.batch,
    required this.stage,
    required this.operation,
    required this.area,
    this.machine,
    this.order,
    this.distributionStageId,
    this.optimalPart,
    this.timestart,
    this.timestop,
    this.timeworking,
    this.user,
    this.chiefBatchId,
    this.chiefOperationId,
    this.modific,
    this.comment,
    this.distributionStage,
    this.listTransfer,
  });

  OperatorOperations copyWith({
    int? id,
    int? timeplan,
    bool? pause,
    int? timeFirstStart,
    Status? status,
    Batch? batch,
    StageDTO? stage,
    OperationDTO? operation,
    AreaDTO? area,
    Machine? machine,
    int? order,
    int? distributionStageId,
    int? optimalPart,
    int? timestart,
    int? timestop,
    int? timeworking,
    User? user,
    int? chiefBatchId,
    int? chiefOperationId,
    bool? modific,
    String? comment,
    List<Transfer>? listTransfer,
  }) {
    return OperatorOperations(
      id: id ?? this.id,
      timeplan: timeplan ?? this.timeplan,
      pause: pause ?? this.pause,
      timeFirstStart: timeFirstStart ?? this.timeFirstStart,
      status: status ?? this.status,
      batch: batch ?? this.batch,
      stage: stage ?? this.stage,
      operation: operation ?? this.operation,
      area: area ?? this.area,
      machine: machine ?? this.machine,
      distributionStageId: distributionStageId ?? this.distributionStageId,
      order: order ?? this.order,
      optimalPart: optimalPart ?? this.optimalPart,
      timestart: timestart ?? this.timestart,
      timestop: timestop ?? this.timestop,
      timeworking: timeworking ?? this.timeworking,
      user: user ?? this.user,
      chiefBatchId: chiefBatchId ?? this.chiefBatchId,
      chiefOperationId: chiefOperationId ?? this.chiefOperationId,
      modific: modific ?? this.modific,
      comment: comment ?? this.comment,
      listTransfer: listTransfer ?? this.listTransfer,
    );
  }

  factory OperatorOperations.fromDTO({required OperatorOperationsDTO dto}) {
    return OperatorOperations(
        timeworking: dto.timeworking,
        optimalPart: dto.optimalPart,
        timeplan: dto.timeplan ?? 0,
        id: dto.id,
        timestop: dto.timestop,
        user: User(
          id: 0,
          fio: dto.staff?.fio ?? 'empty',
          positionId: dto.staff?.positionId ?? 0,
          companyId: 0,
          unitId: 0,
          areaId: 0,
          photo: '',
          company: Company(id: 0, name: '', code: ''),
          position: Position(
              id: dto.staff?.position?.id ?? 0,
              name: dto.staff?.position?.name ?? ''),
        ),
        machine: Machine(
            id: 0,
            isActivated: dto.machine?.isActivated ?? false,
            inventoryNumber: dto.machine?.inventoryNumber ?? 0,
            name: dto.machine?.name ?? 'empty_machine_name',
            areaId: 0),
        timeFirstStart: dto.timeFirstStart ?? 0,
        comment: dto.comment,
        status: Status(id: dto.status.id, name: dto.status.name),
        batch: Batch(
            id: dto.batch.id,
            numberRS: dto.batch.numberRS,
            name: dto.batch.name,
            number: dto.batch.number,
            count: dto.batch.count,
            code: dto.batch.code,
            technology: dto.batch.technology,
            order: Order(
                id: dto.batch.order?.id ?? 0,
                number: dto.batch.order?.number ?? '',
                priority: dto.batch.order?.priority ?? 0,
                statusId: dto.batch.order?.statusId ?? 0),
            orderId: dto.batch.orderId),
        stage: dto.stage ?? StageDTO.empty,
        distributionStage: DistributionStage(
            id: dto.distributionStageDto?.id ?? 0,
            chiefBatchId: dto.distributionStageDto?.chiefBatchId ?? 0,
            unit: Unit(
                id: dto.distributionStageDto?.unitDto?.id ?? 0,
                name: dto.distributionStageDto?.unitDto?.name,
                number: dto.distributionStageDto?.unitDto?.number,
                companyId: dto.distributionStageDto?.unitDto?.companyId ?? 0),
            stageId: dto.distributionStageDto?.stageId ?? 0,
            statusId: dto.distributionStageDto?.statusId ?? 0),
        operation: dto.operation,
        area: dto.area ?? AreaDTO(id: 0, name: '', number: '', unitId: 0));
  }
}
