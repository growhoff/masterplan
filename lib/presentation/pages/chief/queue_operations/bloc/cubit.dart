import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
// import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/presentation/pages/chief/queue_operations/model/distrib_item.dart';
// import 'package:master_plan/presentation/pages/chief_master/pages/queue/queue_details/model/item_area.dart';
// import '../model/item_machine.dart';
// import '../model/item_oper.dart';
// import '../model/item_saver.dart';
import 'state.dart';
// import 'package:collection/collection.dart';

class CubitOperatQueueMasterChM extends Cubit<StateOperatQueueMasterChM> {
  // final List<Machine>? machineList;
  final List<OperatorOperations>? queueList;
  // final List<int> machineIdList;
  final int userId;
  final List<Area> listArea;
   final List<AreaMachine> listAreaMachine;
  final tableOperations = OperatorOperationsTable();

  CubitOperatQueueMasterChM(this.queueList,this.userId, this.listArea, this.listAreaMachine) : super(const StateOperatQueueMasterChM()) {
    emit(state.copyWith(listAreaMachine: listAreaMachine));
    tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', listAreaMachine[state.activeArea].idListMachine).listen((event) {}).onData((data) async {
      await getQuere(data);
    });
  }

  
  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    List<int> listId = [];
    for (var element in data!) {
      if (element['status_id'] as int == 3) listId.add(element['id']);
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
        if ((int.parse(batchId) == el.batchId) && (int.parse(stageId) == el.stageId) && (int.parse(operId) == el.operationId) && (el.statusId == 3 && el.modific == null)) listTrue.add(el);
        if ((int.parse(batchId) == el.batchId) && (int.parse(stageId) == el.stageId) && (int.parse(operId) == el.operationId) && (el.statusId == 3 && el.modific == true)) listTrueMod.add(el);
      }
      if (listTrue.isNotEmpty) listResOper.add(convertToDistrib(listTrue));
      if (listTrueMod.isNotEmpty) listResOper.add(convertToDistrib(listTrueMod));
    }

    emit(state.copyWith(listResOper: listResOper));
  }

    DistribItem convertToDistrib(List<OperatorOperationsDTO> operOperat) {
      int timeSH = operOperat.first.operation.timeSH ?? 0;
      int timePZ = operOperat.first.operation.timepz;
      List<OperatorOperations> list = [];
      for (var element in operOperat) {
        list.add(convertDto(element));
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

  OperatorOperations convertDto(OperatorOperationsDTO dto) {
    return OperatorOperations(
      id: dto.id,
      area: dto.area!,
      operation: dto.operation,
      stage: dto.stage!,
      timeplan: dto.timeplan ?? 0,
      timeFirstStart: dto.timeFirstStart ?? 0,
      timestart: dto.timestart,
      timestop: dto.timestop,
      timeworking: dto.timeworking,
      status: Status(id: dto.status.id, name: dto.status.name),
      batch: Batch(id: dto.batch.id,
          numberRS: dto.batch.numberRS,
          name: dto.batch.name,
          count: dto.batch.count,
          code: dto.batch.code,
          orderId: dto.batch.orderId,
          technology: dto.batch.technology,

          isready: dto.batch.isready),
      order: dto.order,
      machine: Machine(id: dto.machine!.id,
          inventoryNumber: dto.machine!.inventoryNumber,
          isActivated: dto.machine!.isActivated,
          name: dto.machine!.name,
          areaId: dto.areaId),
      chiefBatchId: dto.chiefBatchId,
      chiefOperationId: dto.chiefOperationId,
      optimalPart: dto.optimalPart,
      modific: dto.modific,
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
    final queue = await tableOperations.selectListMachineId(state.listAreaMachine[index].idListMachine);
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
}