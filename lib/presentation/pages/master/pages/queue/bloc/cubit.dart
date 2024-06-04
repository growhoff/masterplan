import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
// import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/status.dart';
// import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_saver.dart';
import 'state.dart';

class CubitQueueMaster extends Cubit<StateQueueMaster> {
  final List<Machine>? machineList;
  final List<OperatorOperations>? queueList;
  final List<int> machineIdList;
  final tableOperations = OperatorOperationsTable();

  CubitQueueMaster(this.machineList, this.queueList, this.machineIdList)
      : super(const StateQueueMaster()) {
    tableOperations.table.stream(primaryKey: ['id']).inFilter(
        'machine_id', machineIdList).listen((event) {}).onData((data) async {
      List<ItemMachine> res = [];
      res = [...await getQuere(data)];
      emit(state.copyWith(listMachine: res));
    });
  }

  Future<List<ItemMachine>> getQuere(List<Map<String, dynamic>>? data) async {
    List<int> listId = [];
    for (var element in data!) {
      if (element['status_id'] as int == 3) listId.add(element['id']);
    }
    final quere = await tableOperations.selectListIdOrder(listId);
    List<OperatorOperationsDTO> queueList = [];
    for (var item in quere) {
      queueList.add(OperatorOperationsDTO.fromMap(item));
    }
    List<ItemMachine> listItem = [];
    for (var machine in machineList!) {
      List<OperatorOperations> listQueue = [];
      int time = 0;
      for (var queueItem in queueList) {
        if (queueItem.machine!.id == machine.id) {
          listQueue.add(convertDto(queueItem));
          // time += queueItem.timeplan!;
          if (queueItem.timeplan == null) {
            time += 0;
          } else {
            time += queueItem.timeplan!;
          }
        }
      }
      listItem.add(
          ItemMachine(machine: machine, listOper: listQueue, time: time));
    }
    return listItem;
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
          packageId: dto.batch.packageId,
          technology: dto.batch.technology,
          order: dto.batch.order,
          isready: dto.batch.isready),
      // user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)),
      order: dto.order,
      machine: Machine(id: dto.machine!.id,
          inventoryNumber: dto.machine!.inventoryNumber,
          name: dto.machine!.name,
          areaId: dto.areaId),
    );
  }

  void updateOperationDistribMaster(int id) {
    final table = OperatorOperationsTable();
    table.updateMasterDistribMaster(id);
  }

  void updateOperationReady(int id) {
    final table = OperatorOperationsTable();
    table.updateMasterReady(id);
  }

  void setActivePage(int index) {
    emit(state.copyWith(activePage: index));
  }

  Future<void> saveDate() async {
    final table = OperatorOperationsTable();
    List<ItemSaver> saveList = [];
    final operList = state.listMachine![state.activePage].listOper;
    for (var i = 0; i < operList.length; i++) {
      saveList.add(ItemSaver(id: operList[i].id, order: i));
    }
    for (var element in saveList) {
      await table.updateOrder(element.id, element.order);
    }
  }
}