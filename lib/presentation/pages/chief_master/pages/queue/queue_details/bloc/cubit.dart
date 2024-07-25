import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/item_saver.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import '../model/item_machine.dart';
import 'state.dart';
import 'package:collection/collection.dart';

class CubitQueueMaster extends Cubit<StateQueueMaster> {
  // final List<OperatorOperations>? queueList;
  final int userId;
  final tableOperations = OperatorOperationsTable();
  final List<AreaMachine> listAreaMachine;
  CubitQueueMaster(this.userId, this.listAreaMachine) : super(const StateQueueMaster()) {
    emit(state.copyWith(listAreaMachine: listAreaMachine));
    setListItemDrop();
    tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', listAreaMachine[state.activeArea].idListMachine).listen((event) {}).onData((data) async {
      await getQuere(data);
    });
  }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    List<int> listId = [];
    for (var element in data!) {
      if ((element['status_id'] as int == 3) || (element['status_id'] as int == 7)) listId.add(element['id']);
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
        list.add(ConvertDtoModel.convertToOperatorOperations(element));
        if (element.timeplan != null) {time += element.timeplan!;}
      }
      listB.add(OptPathOperations(idPath: key!, list: list, order: list.first.order!, time: time, active: list.first.status.id == 7));
    });

    listB.sort((a, b) => a.order!.compareTo(b.order!));

    List<ItemMachine> listItem = [];
    for (var machine in listAreaMachine[state.activeArea].listMachine) {
      List<OptPathOperations> listQueue = [];
      int time = 0;
      OptPathOperations? activeOper;
      for (var item in listB) {
        if (item.list.first.machine!.id == machine.id) {
          if (!item.active!){
            listQueue.add(item);
            time +=item.time;
          }else{
            activeOper = item;
          }
        }
      }
      listItem.add(ItemMachine(machine: machine, listOper: listQueue, time: time, activeOper: activeOper));
    }
    emit(state.copyWith(listMachine: listItem));
  }

  void updateOperationDistribMaster(int id) {
    tableOperations.updateMasterDistribMasterEqOptimalPart(id);
  }

  void updateOperationReady(int idPath) {
    tableOperations.updateMasterReadyEqOptimalPart(idPath, userId);
  }

  void setListItemDrop() {
    List<NameIndex> listItemArea = [];
    List<NameIndex> listItemMachine = [];
    if (state.listAreaMachine.isNotEmpty) {
      for (var i = 0; i < state.listAreaMachine.length; i++) {
        listItemArea.add(NameIndex(name: state.listAreaMachine[i].area.name, index: i));
      }

      if (state.listAreaMachine[state.activeArea].listMachine.isNotEmpty) {
        var listMachine = state.listAreaMachine[state.activeArea].listMachine;
        for (var i = 0; i < listMachine.length; i++) {
          listItemMachine.add(NameIndex(name: listMachine[i].name, index: i));
        }
      }
    }
    emit(state.copyWith(listItemArea: listItemArea, listItemMachine: listItemMachine));
  }

  void setActiveMachine(int index) {
    emit(state.copyWith(activeMachine: index));
  }

  Future<void> setActiveArea(int index) async{
    emit(state.copyWith(activeArea: index, activeMachine: 0, listMachine: []));
    setListItemDrop();
    final queue = await tableOperations.selectListMachineId(state.listAreaMachine[index].idListMachine);
    await getQuere(queue);
  }
////
///
///
  void setIsSaver(bool isSaver){
    emit(state.copyWith(isSaver: isSaver));
  }

  Future<void> saveDate() async {
    final tableOperations = OperatorOperationsTable();
    List<ItemSaver> saveList = [];
    final list = state.listMachine![state.activeMachine].listOper;
    for (var i = 0; i <  list.length; i++) {
      saveList.add(ItemSaver(idPath: list[i].idPath, order: i));
    }
    for (var element in saveList) {
      await tableOperations.updateOrder(element.idPath, element.order);
    }

    emit(state.copyWith(isSaver: false));
  }
}