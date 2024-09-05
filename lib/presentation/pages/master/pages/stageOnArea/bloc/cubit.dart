import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/model/batch_view.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/model/chief_distribution_batch.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/model/chief_distribution_stage.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/model/stage_view.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/model/view_content.dart';
import 'state.dart';

class CubitStageOnArea extends Cubit<StateStageOnArea> {
  final tableOperations = OperatorOperationsTable();
  final tableDistributionStage = DistributionStageTable();
  final int areaIdUser;

  CubitStageOnArea(this.areaIdUser) : super(const StateStageOnArea()){
    getQuere();
  }

  Future<void> getQuere()async{
    final quereOperat = await tableOperations.selectAreaId(areaIdUser);
    Set<String> listChiefBatchAndStageId = {};
    Set<int> listChiefBatchId = {};
    Set<int> listIdBatch = {};
    List<OperatorOperationsDTO> listOper = [];
    for (var item in quereOperat) {
      final model = OperatorOperationsDTO.fromMap(item);
      listChiefBatchAndStageId.add('${model.chiefBatchId}_${model.stageId}');
      listChiefBatchId.add(model.chiefBatchId!);
      listIdBatch.add(model.batchId);
      listOper.add(model);
    }

    var newListChief = groupBy(listOper, (el) => el.chiefBatchId);
    List<BatchView> listBatch = [];
    newListChief.forEach((keyChiefBatchId, valueChiefBatchId){
      var newStageList = groupBy(valueChiefBatchId, (elStage) => elStage.stageId);
      List<StageView> stageListNew = [];
      newStageList.forEach((keyStage, valueStage){
        stageListNew.add(StageView(stageId: keyStage, listOper: valueStage));
      });
      listBatch.add(BatchView(batchId: valueChiefBatchId.first.batchId, listStage: stageListNew));
    });

    List<ChiefDistributionBatch> listSearch = await getSearchList(listIdBatch.toList());
    
    List<ViewContent> listRes = [];
    for (var batch in listBatch) {
      int countOperStage = 0;
      for (var elementSearch in listSearch) {
        if (batch.batchId == elementSearch.batchId){
          for (var elementStage in batch.listStage) {
            for (var stage in elementSearch.stageList) {
              if (elementStage.stageId == stage.stageId){
                int selectOperStage = 0;
                countOperStage = stage.operIdList.length;
                for (var i = 0; i < stage.operIdList.length; i++) {
                  for (var element in elementStage.listOper) {
                    if (element.operationId == stage.operIdList[i]){
                      if (element.statusId == 5 || element.statusId == 6 || element.statusId == 9) selectOperStage++;
                    }
                  }
                }
                listRes.add(ViewContent(
                  stageNumber: elementStage.listOper.first.batch.order == null ? '${elementStage.listOper.first.batch.name}.${elementStage.listOper.first.batch.number}.${elementStage.listOper.first.stage?.number}' : '${elementStage.listOper.first.batch.order!.number}.${elementStage.listOper.first.batch.number}.${elementStage.listOper.first.stage?.number}', 
                  batchNumber: elementStage.listOper.first.batch.numberRS, 
                  batchName: elementStage.listOper.first.batch.name, 
                  precentPerfect: ((selectOperStage/countOperStage)*100).round(),
                  chiefBatchId: elementStage.listOper.first.chiefBatchId ?? 0,
                  stageId: elementStage.stageId,
                  batch: ConvertDtoModel.convertToBatch(elementStage.listOper.first.batch), 
                  status: ''));
              }
            }
          }
        }
      }
    }

    var newListRes = groupBy(listRes, (el) => el.stageNumber);
    listRes.clear();
    newListRes.forEach((key, value) => listRes.add(value.first));

    //выгрузка инфа для статусов
    List<DistributionStageDto> distribStageDtoList = [];
    final quereDistrib = await tableDistributionStage.selectByChiefBatchIdsList(listChiefBatchId.toList());
    for (var element in quereDistrib) {
      distribStageDtoList.add(DistributionStageDto.fromMap(element));
    }

    //добавление статуса
    for (var item in listRes) {
      for (var element in distribStageDtoList) {
        if (element.chiefBatchId == item.chiefBatchId && element.stageId == item.stageId){item.status = element.stageStatus!.name;}
      }
    }

    emit(state.copyWith(listRes: listRes));
  }

  Future<List<ChiefDistributionBatch>> getSearchList(List<int> batchIdList)async{
    //выгрузка для проверки количества этапов
    final tableChief = ChiefDistributionOperationsTable();
    final quereChief = await tableChief.selectListBatchId(batchIdList);
    List<ChiefDistributionOperationsDTO> listChiefDto = [];
    for (var element in quereChief) {
      listChiefDto.add(ChiefDistributionOperationsDTO.fromMap(element));
    }
    List<ChiefDistributionBatch> listBatchSearch = [];
    var newListChief = groupBy(listChiefDto, (el) => el.batchId);
    newListChief.forEach((key, value){
      var newStageList = groupBy(value, (elStage) => elStage.stageId);
      List<ChiefDistributionStage> listStage = [];
      newStageList.forEach((keyStage, valueStage){
        List<int> operIdList = [];
        for (var el in valueStage) {
          operIdList.add(el.operationId);
        }
        listStage.add(ChiefDistributionStage(stageId: keyStage, operIdList: operIdList));
      });
      listBatchSearch.add(ChiefDistributionBatch(batchId: key, stageList: listStage));
    });
    return listBatchSearch;
  }

  Color? readyPercentToColor(int readyPercent) {
  if (readyPercent >= 1 && readyPercent < 25) {return Colors.green[100];}
  if (readyPercent >= 25 && readyPercent < 50) {return Colors.green[200];}
  if (readyPercent >= 50 && readyPercent < 75) {return Colors.green[300];}
  if (readyPercent >= 75 && readyPercent < 100) {return Colors.green[400];}
  if (readyPercent == 100) {return Colors.green[500];}
  return Colors.white54;
}
}