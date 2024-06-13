import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/status.dart';
import '../model/item_machine.dart';
import '../model/item_oper.dart';
import '../model/item_saver.dart';
import 'state.dart';
import 'package:collection/collection.dart';

class CubitQueueMasterChM extends Cubit<StateQueueMasterChM> {
  final List<Machine>? machineList;
  final List<OperatorOperations>? queueList;
  final List<int> machineIdList;
  final int userId;
  final tableOperations = OperatorOperationsTable();

  CubitQueueMasterChM(this.machineList, this.queueList, this.machineIdList, this.userId) : super(const StateQueueMasterChM()) {
    tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', machineIdList).listen((event) {}).onData((data) async {
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

    List<ItemOper> listB = [];
    var newMap = groupBy(queueList, (el) => el.optimalPart);
    newMap.forEach((key, value) {
      List<OperatorOperations> list = [];
      for (var element in value) {
        list.add(convertDto(element));
      }
      listB.add(ItemOper(idPath: key!, list: list));
    });

    // List<ItemMachine> listItem = [];
    // for (var machine in machineList!) {
    //   List<OperatorOperations> listQueue = [];
    //   int time = 0;
    //   for (var queueItem in queueList) {
    //     if (queueItem.machine!.id == machine.id) {
    //       listQueue.add(convertDto(queueItem));
    //       if (queueItem.timeplan == null) {
    //         time += 0;
    //       } else {
    //         time += queueItem.timeplan!;
    //       }
    //     }
    //   }
    //   listItem.add(ItemMachine(machine: machine, listOper: listQueue, time: time));
    // }

    List<ItemMachine> listItem = [];
    for (var machine in machineList!) {
      List<ItemOper> listQueue = [];
      int time = 0;
      for (var item in listB) {
        if (item.list.first.machine!.id == machine.id) {
          listQueue.add(item);
          // if (item.timeplan == null) {
          //   time += 0;
          // } else {
          //   time += item.timeplan!;
          // }
        }
      }
      listItem.add(ItemMachine(machine: machine, listOper: listQueue, time: time));
    }
    emit(state.copyWith(listMachine: listItem));
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
    );
  }

  void updateOperationDistribMaster(int id) {
    tableOperations.updateMasterDistribMasterEqOptimalPart(id);
  }

  void updateOperationReady(int idPath) {
    tableOperations.updateMasterReadyEqOptimalPart(idPath, userId);
  }

  void setActivePage(int index) {
    emit(state.copyWith(activePage: index));
  }

  Future<void> saveDate() async {
    List<ItemSaver> saveList = [];
    final operList = state.listMachine![state.activePage].listOper;
    for (var i = 0; i < operList.length; i++) {
      // List<int> idL = [];
      // for (var oper in operList[i].list) {
      //   idL.add(oper.id);
      // }
      saveList.add(ItemSaver(idPath: operList[i].idPath, order: i));
    }
    for (var element in saveList) {
      await tableOperations.updateOrder(element.idPath, element.order);
    }
  }
}