import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/domain/model/status.dart';
// import 'package:master_plan/presentation/pages/chief_master/pages/queue/queue_details/model/item_area.dart';
import '../model/item_machine.dart';
// import '../model/item_oper.dart';
import '../model/item_saver.dart';
import 'state.dart';
import 'package:collection/collection.dart';

class CubitQueueMasterChM extends Cubit<StateQueueMasterChM> {
  // final List<Machine>? machineList;
  final List<OperatorOperations>? queueList;
  // final List<int> machineIdList;
  final int userId;
  final List<Area> listArea;
  final List<AreaMachine> listAreaMachine;
  final tableOperations = OperatorOperationsTable();

  CubitQueueMasterChM(this.queueList,  this.userId, this.listArea, this.listAreaMachine) : super(const StateQueueMasterChM()) {
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
    List<OperatorOperationsDTO> queueList = [];
    for (var item in quere) {
      queueList.add(OperatorOperationsDTO.fromMap(item));
    }

    List<OptPathOperations> listB = [];
    var newMap = groupBy(queueList, (el) => el.optimalPart);
    newMap.forEach((key, value) {
      List<OperatorOperations> list = [];
      int time = 0;
      for (var element in value) {
        list.add(convertDto(element));
        if (element.timeplan != null) {time += element.timeplan!;}
      }
      listB.add(OptPathOperations(idPath: key!, list: list, order: list.first.order!, time: time, machine: list.first.machine!, area: list.first.area));
    });

    listB.sort((a, b) => a.order!.compareTo(b.order!));

    // List<ItemArea> listItemArea = [];
    // for (var area in listAreaMachine) {
    //   List<ItemMachine> listItemMachine = [];
    //   for (var machine in area.listMachine) {
    //     List<ItemOper> listQueue = [];
    //     int time = 0;
    //     for (var item in listB) {
    //       if (item.list.isNotEmpty && (item.list.first.machine!.id == machine.id)) {
    //         listQueue.add(item);
    //         time +=item.time;
    //       }
    //     }
    //     listItemMachine.add(ItemMachine(machine: machine, listOper: listQueue, time: time));
    //   }
    // listItemArea.add(ItemArea(area: area.area, list: listItemMachine));
    // }

    List<ItemMachine> listItem = [];
    for (var machine in listAreaMachine[state.activeArea].listMachine) {
      List<OptPathOperations> listQueue = [];
      int time = 0;
      for (var item in listB) {
        if (item.list.first.machine!.id == machine.id) {
          listQueue.add(item);
          time +=item.time;
        }
      }
      listItem.add(ItemMachine(machine: machine, listOper: listQueue, time: time));
    }
    emit(state.copyWith(listMachine: listItem));

    // emit(state.copyWith(listItemArea: listItemArea));
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
          number: dto.batch.number,
          name: dto.batch.name,
          count: dto.batch.count,
          code: dto.batch.code,
          orderId: dto.batch.orderId,
          technology: dto.batch.technology,
          order: dto.batch.order,
          isready: dto.batch.isready),
      order: dto.order,
      machine: Machine(id: dto.machine!.id,
          inventoryNumber: dto.machine!.inventoryNumber,
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

  void setActiveMachine(int index) {
    emit(state.copyWith(activeMachine: index));
  }

  Future<void> setActiveArea(int index) async{
    emit(state.copyWith(activeArea: index, activeMachine: 0, listMachine: []));
    final queue = await tableOperations.selectListMachineId(state.listAreaMachine[index].idListMachine);
    await getQuere(queue);
  }

  Future<void> saveDate() async {
    List<ItemSaver> saveList = [];
    final operList = state.listMachine![state.activeMachine].listOper;
    for (var i = 0; i < operList.length; i++) {
      saveList.add(ItemSaver(idPath: operList[i].idPath, order: i));
    }
    for (var element in saveList) {
      await tableOperations.updateOrder(element.idPath, element.order);
    }
  }
}