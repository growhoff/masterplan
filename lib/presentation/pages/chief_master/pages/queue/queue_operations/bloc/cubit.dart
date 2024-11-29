import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import '../model/distrib_item.dart';
import 'state.dart';

class CubitOperatQueueMasterChM extends Cubit<StateOperatQueueMasterChM> {
  final List<OperatorOperations>? queueList;
  final int userId;
  final List<Area> listArea;
   final List<AreaMachine> listAreaMachine;
  final tableOperations = OperatorOperationsTable();

  CubitOperatQueueMasterChM( this.queueList,  this.userId, this.listArea, this.listAreaMachine) : super(const StateOperatQueueMasterChM()) {
    emit(state.copyWith(listAreaMachine: listAreaMachine));
    tableOperations.table.stream(primaryKey: ['id']).inFilter('area_id', [listAreaMachine[state.activeArea].area.id]).listen((event) {}).onData((data) async {
      await getQuere(data);
    });
  }

  
  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    List<int> listId = [];
    for (var element in data!) {
      if (element['status_id'] as int == 2 || element['status_id'] as int == 3 || element['status_id'] as int == 4) listId.add(element['id']);
    }
    final quere = await tableOperations.selectListIdOrder(listId);
    Set<String> setAllId = {};
    List<OperatorOperationsDTO> queueList = [];
    for (var item in quere) {
      final model = OperatorOperationsDTO.fromMap(item);
      queueList.add(model);
      setAllId.add('${model.batchId}_${model.stageId}_${model.operationId}');
    }

    // List<OptPathOperations> listB = [];
    // var newMap = groupBy(queueList, (el) => el.optimalPart);
    // newMap.forEach((key, value) {
    //   List<OperatorOperations> list = [];
    //   int time = 0;
    //   for (var element in value) {
    //     list.add(convertDto(element));
    //     if (element.timeplan != null) {time += element.timeplan!;}
    //   }
    //   listB.add(OptPathOperations(idPath: key!, list: list, order: list.first.order!, time: time, machine: list.first.machine!, area: list.first.area));
    // });

    // listB.sort((a, b) => a.order!.compareTo(b.order!));

    //группировка по операциям
    List<DistribItem> listResOper = [];
    for (var setI in setAllId) {
      final listName = setI.split('_');
      final batchId = listName[0];
      final stageId = listName[1];
      final operId = listName[2];
      //разделение на два массива с доработкой и на распределении
      List<OperatorOperationsDTO> listTrue = [];
      List<OperatorOperationsDTO> listTrueMod = [];
      for (var el in queueList) {
        if ((int.parse(batchId) == el.batchId) && (int.parse(stageId) == el.stageId) && (int.parse(operId) == el.operationId) && (el.modific == null)) listTrue.add(el);
        if ((int.parse(batchId) == el.batchId) && (int.parse(stageId) == el.stageId) && (int.parse(operId) == el.operationId) && (el.modific == true)) listTrueMod.add(el);
      }
      if (listTrue.isNotEmpty) listResOper.add(convertToDistrib(listTrue));
      if (listTrueMod.isNotEmpty) listResOper.add(convertToDistrib(listTrueMod));
    }

    emit(state.copyWith(listResOper: listResOper));
  }

    DistribItem convertToDistrib(List<OperatorOperationsDTO> operOperat) {
      int timeSH = operOperat.first.operation.timeSH;
      int timePZ = operOperat.first.operation.timepz;
      List<OperatorOperations> list = [];
      for (var element in operOperat) {
        list.add(ConvertDtoModel.convertToOperatorOperations(element));
      }
    return DistribItem(
        stageNumber: '${operOperat.first.stage!.number} ${operOperat.first.stage!.name}',
        detailNumber: '${operOperat.first.batch.numberRS} ${operOperat.first.batch.name}',
        operationName: '${operOperat.first.operation.number} ${operOperat.first.operation.name}',
        count: operOperat.length,
        listOperat: list,
        timeSh: timeSH,
        timePZ: timePZ,
        timeShKal: ((timeSH + (timePZ/operOperat.length))*operOperat.length)
        );
  }

  void updateOperationDistribMaster(int id) {
    tableOperations.updateMasterDistribMasterEqOptimalPart(id);
  }

  void updateOperationReady(int idPath) {
    tableOperations.updateMasterReadyEqOptimalPart(idPath, userId);
  }

  Future<void> setActiveArea(int index) async{
    emit(state.copyWith(activeArea: index, activeMachine: 0, listResOper: []));
    final queue = await tableOperations.selectAreaId(state.listAreaMachine[index].area.id);
    await getQuere(queue);
  }

  Future<void> saveDate() async {
    // List<ItemSaver> saveList = [];
    // final operList = state.listOper!;
    // for (var i = 0; i < operList.length; i++) {
    //   saveList.add(ItemSaver(idPath: operList[i].idPath, order: i));
    // }
    // for (var element in saveList) {
    //   await tableOperations.updateOrder(element.idPath, element.order);
    // }
  }

  Future<void> saveDateList(DistribItem distrib, int index) async {
    final tableChiefOper = ChiefOperationTable();
    final tableChiefDistribut = ChiefDistributionOperationsTable();
    final stageId = distrib.listOperat.first.stage.id;
    final operId = distrib.listOperat.first.operation.id;
    final batchId = distrib.listOperat.first.batch.id;
    
    List<int> chiefBatchIdList = [];
    List<int> listOperId = [];
    for (var el in distrib.listOperat) {
      if (el.chiefBatchId != null) chiefBatchIdList.add(el.chiefBatchId!);
      listOperId.add(el.id);
    }
    await tableChiefDistribut.updateQuere(stageId: stageId, operationId: operId, batchId: batchId, quantity: distrib.listOperat.length);
    await tableChiefOper.updateSelect(chiefBatchId: chiefBatchIdList, stageId: stageId, operationId: operId);
    await tableOperations.deleteListId(listOperId);
    List<DistribItem> listResOper = state.listResOper;
    listResOper.removeAt(index);
    emit(state.copyWith(listResOper: []));
    emit(state.copyWith(listResOper: listResOper));
  }
}