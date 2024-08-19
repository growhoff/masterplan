import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/model/order.dart';
import 'package:meta/meta.dart';

import '../../../../../data/repositories/supabase/dto/distribution_stage_dto.dart';
import '../../../../../data/repositories/supabase/dto/operation_dto.dart';
import '../../../../../data/repositories/supabase/dto/operator_operations_dto.dart';
import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/distribution_stage.dart';
import '../../../../../domain/model/operation.dart';
import '../../../../../domain/model/unit.dart';
import '../../../chief/stages_in_unit_page/stages_in_unit_model.dart';
import '../../orders_page/batches_page/batch_model.dart';

part 'queue_stages_state.dart';

class QueueStagesCubit extends Cubit<QueueStagesState> {
  QueueStagesCubit()
      : super(QueueStagesState(status: QueueStagesPageStatus.initial));

  final _distributionStageTable = DistributionStageTable();

  final _unitTable = UnitTable();

  Unit selectedUnit = Unit(id: 0, companyId: 0);

  Future fetchUnits() async {
    List<Unit> unitsList = [];

    var fetchedUnitsList = await _unitTable.select();

    for (var fetchedUnit in fetchedUnitsList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);

      final unit = Unit(
          id: unitDto.id,
          companyId: unitDto.companyId,
          name: unitDto.name,
          number: unitDto.number);

      unitsList.add(unit);
    }

    selectedUnit = unitsList.first;

    emit(state.copyWith(unitsList: unitsList));
  }

  Future fetchStages() async {
    emit(state.copyWith(status: QueueStagesPageStatus.loading));
    List<DistributionStage> distributionStagesList = [];
    List<StageModel> stagesInBatchModelList = [];

    var fetchedStagesList =
        await _distributionStageTable.selectByUnitId(selectedUnit.id);

    for (var fetchedStage in fetchedStagesList) {
      final fetchedStageDto = DistributionStageDto.fromMap(fetchedStage);

      final distributionStage = DistributionStage.fromDto(fetchedStageDto);

      distributionStagesList.add(distributionStage);
    }

    var stagesMap = groupBy(distributionStagesList, (stage) => stage.stageId);

    stagesMap.forEach((key, value) {
      // print('value number: ${value.first.chiefBatch?.batch.number}');

      final stageModel = StageModel(
          batch: Batch(
              id: value.first.chiefBatch?.batch.id ?? 0,
              numberRS: value.first.chiefBatch?.batch.numberRS ?? '',
              number: value.first.chiefBatch?.batch.number,
              name: value.first.chiefBatch?.batch.name ?? '',
              order: Order(
                  id: value.first.chiefBatch?.batch.order?.id ?? 0,
                  number: value.first.chiefBatch?.batch.order?.number ?? '',
                  priority: value.first.chiefBatch?.batch.order?.priority ?? 0,
                  statusId: value.first.chiefBatch?.batch.order?.statusId ?? 0),
              count: value.first.chiefBatch?.batch.count ?? 0,
              code: value.first.chiefBatch?.batch.code ?? '',
              technology: value.first.chiefBatch?.batch.technology ?? '',
              isready: value.first.chiefBatch?.batch.isready ?? false,
              orderId: value.first.chiefBatch?.batch.orderId),
          stageId: value.first.stageId,
          stageNumber: value.first.stage?.number ?? '',
          stageName: value.first.stage?.name ?? '',
          unitNumber: value.first.unit?.number ?? '');

      List<int> stagesStatusesIdsList = [];
      for (var stage in value) {
        stageModel.distributionStagesIdsList.add(stage.id);
        stagesStatusesIdsList.add(stage.statusId);
        switch (stage.statusId) {
          case 2:
            stageModel.inWorkQuantity++;
          case 3:
            stageModel.readyToUploadQuantity++;
            stagesStatusesIdsList.add(stage.statusId);
          case 4:
            stageModel.uploadedQuantity++;
          case 5:
            stageModel.defectQuantity++;
        }
      }

      stageModel.allOnStageQuantity =
          stageModel.inWorkQuantity + stageModel.readyToUploadQuantity;

      stageModel.readyQuantity =
          stageModel.readyToUploadQuantity + stageModel.uploadedQuantity;

      stagesInBatchModelList.add(stageModel);

      if (stageModel.uploadedQuantity != 0 && stageModel.readyQuantity != 0) {
        stageModel.readyPercent =
            ((stageModel.uploadedQuantity / stageModel.readyQuantity) * 100)
                .round();
      }

      print(stagesStatusesIdsList);

      if (stagesStatusesIdsList.contains(1)) {
        stageModel.status = 'На распределении';
      } else {
        if (stagesStatusesIdsList.contains(2)) {
          stageModel.status = 'Выполняется';
        } else {
          if (stagesStatusesIdsList.contains(3)) {
            stageModel.status = 'Частично готов';
          } else {
            if (stagesStatusesIdsList.contains(4)) {
              stageModel.status = 'Готов';
            }
          }
        }
      }

      stagesInBatchModelList
          .sort((a, b) => a.readyPercent.compareTo(b.readyPercent));

      //stagesInBatchModelList.forEach((stage) => print('batch number: ${stage.batch.number}'));

      emit(state.copyWith(
          status: QueueStagesPageStatus.success,
          stagesList: stagesInBatchModelList.reversed.toList()));
    });
  }


  Future redistribute()async{

  }

  Future initQueueStagesPage() async {
    await fetchUnits();
    await fetchStages();
  }
}
