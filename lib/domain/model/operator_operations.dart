// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/user.dart';

import 'distribution_stage.dart';

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
  final int? optimalPart;

  final int? timestart;
  final int? timestop;
  final int? timeworking;
  final User? user;
  final int? chiefBatchId;
  final int? chiefOperationId;
  final bool? modific;
  final String? comment;

  final DistributionStage? distributionStageDto;

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
    this.optimalPart,

    this.timestart,
    this.timestop,
    this.timeworking,
    this.user,
    this.chiefBatchId,
    this.chiefOperationId,
    this.modific,
    this.comment,
    this.distributionStageDto
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
    int? optimalPart,
    int? timestart,
    int? timestop,
    int? timeworking,
    User? user,
    int? chiefBatchId,
    int? chiefOperationId,
    bool? modific,
    String? comment,
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
    );
  }
}
