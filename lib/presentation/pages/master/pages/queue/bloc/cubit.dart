import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/group_opt_path.dart';
import 'package:master_plan/domain/model/item_machine.dart';
import 'package:master_plan/domain/model/item_saver.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/domain/usecase/operation_group.dart';
import 'state.dart';

class CubitQueueMaster extends Cubit<StateQueueMaster> {
  final int userId;
  final tableOperations = OperatorOperationsTable();
  final List<AreaMachine> listAreaMachine;
  bool isActiveStream = true;
  CubitQueueMaster(this.userId, this.listAreaMachine) : super(const StateQueueMaster()) {
    emit(state.copyWith(listAreaMachine: listAreaMachine));
    setListItemDrop();
    tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', listAreaMachine[state.activeArea].idListMachine).listen((event) {}).onData((data) async {
      if (isActiveStream) await getQuere(data);
    });
  }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    emit(state.copyWith(isLoading: true));
    List<int> listId = [];
    for (var element in data!) {
      if ((element['status_id'] as int == 3) || (element['status_id'] as int == 7)) listId.add(element['id']);
    }
    final quere = await tableOperations.selectListIdOrder(listId);
    List<OperatorOperationsDTO> queueList = [];
    for (var item in quere) {queueList.add(OperatorOperationsDTO.fromMap(item));}

    List<ItemMachine> listItem = [];
    if (queueList.isNotEmpty){
      List<OptPathOperations> listB = OperationsGroup().group(queueList);
      listB.sort((a, b) => a.order!.compareTo(b.order!));
      listItem = OperationsGroup().groupMachine(listAreaMachine[state.activeArea].listMachine, listB);
    }
    
    emit(state.copyWith(listMachine: listItem, isLoading: false));
  }

  Future<void> updateOperationDistribMaster(int id) async{
    await tableOperations.updateMasterDistribMasterEqOptimalPart(id);
  }

  Future<void> updateOperationReady(List<OptPathOperations> listOptPath) async{
    await tableOperations.updateMasterReadyEqOptimalPart(listOptPath.first.idPath, userId);
    await updateStatusBatchChiefBatchStage(listOptPath);
  }

  Future<void> updateStatusBatchChiefBatchStage(List<OptPathOperations> listOptPath)async{
      List<int> listIdBatch = [];
      List<int> listIdChiefBatch = [];
      List<int> listIdOrder = [];
      for (var optPath in listOptPath) {
        for (var e in optPath.list) {
          listIdBatch.add(e.batch.id);
          listIdChiefBatch.add(e.chiefBatchId!);
          listIdOrder.add(e.batch.orderId!);
        }
      }
      await setBatchStatus(listIdBatch);
      await setChiefBatchStatus(listIdChiefBatch);
      await setOrderBatchStatus(listIdOrder);
      for (var optPath in listOptPath) {
        await setDistribStageStatus(optPath.list);
      }
  }

  Future<void> setBatchStatus(List<int> listIdBatch)async{
    final batchTable = BatchTable();
    await batchTable.updateStatusJob(listIdBatch);
  }

  Future<void> setChiefBatchStatus(List<int> listIdCiefBatch)async{
    final chiefBatchTable = ChiefBatchTable();
    await chiefBatchTable.updateStatusJob(listIdCiefBatch);
  }

  Future<void> setDistribStageStatus(List<OperatorOperations> list)async{
    final distribStageTable = DistributionStageTable();
    for (var e in list) {
      await distribStageTable.updateStatusJob(e.stage.id, e.chiefBatchId!);
    }
  }

  Future<void> setOrderBatchStatus(List<int> listIdOrder)async{
    final orderTable = OrderTable();
    await orderTable.updateStatusJob(listIdOrder);
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
    final queue = await tableOperations.selectListMachineId(state.listAreaMachine[index].idListMachine);
    await getQuere(queue);
  }

  void groupNameOper(){
    List<GroupOptPath> list = OperationsGroup().groupOperInMachineBatchNum(state.listMachine![state.activeMachine]);
    List<ItemMachine> listMachine = state.listMachine!;
    List<ItemMachine> newList = [];
    listMachine[state.activeMachine] = ItemMachine(machine: listMachine[state.activeMachine].machine, listPathOper: list, time: listMachine[state.activeMachine].time);
    newList.addAll(listMachine);
    emit(state.copyWith(listMachine: []));
    emit(state.copyWith(listMachine: newList, isGroup: true));
  }

  void groupStageNumber(){
    List<GroupOptPath> list = OperationsGroup().groupOperInMachineStageNumber(state.listMachine![state.activeMachine]);
    List<ItemMachine> listMachine = state.listMachine!;
    List<ItemMachine> newList = [];
    listMachine[state.activeMachine] = ItemMachine(machine: listMachine[state.activeMachine].machine, listPathOper: list, time: listMachine[state.activeMachine].time);
    newList.addAll(listMachine);
    emit(state.copyWith(listMachine: []));
    emit(state.copyWith(listMachine: newList, isGroup: true));
  }

  void reGroup(){
    List<GroupOptPath> list = OperationsGroup().groupOperInMachineOptPath(state.listMachine![state.activeMachine]);
    List<ItemMachine> listMachine = state.listMachine!;
    List<ItemMachine> newList = [];
    listMachine[state.activeMachine] = ItemMachine(machine: listMachine[state.activeMachine].machine, listPathOper: list, time: listMachine[state.activeMachine].time);
    newList.addAll(listMachine);
    emit(state.copyWith(listMachine: []));
    emit(state.copyWith(listMachine: newList, isGroup: false));
  }

  void choiseOptPath(int index){
    List<ItemMachine> listMachine = state.listMachine!;
    GroupOptPath operOld = listMachine[state.activeMachine].listPathOper[index];
    listMachine[state.activeMachine].listPathOper[index] = GroupOptPath(listOptPath: operOld.listOptPath, count: operOld.listOptPath.length, isChoise: !operOld.isChoise);
    emit(state.copyWith(listMachine: []));
    emit(state.copyWith(listMachine: listMachine));
  }

  void getUp(){
    List<GroupOptPath> list = OperationsGroup().regroupUp(state.listMachine![state.activeMachine]);
    List<ItemMachine> listMachine = state.listMachine!;
    List<ItemMachine> newList = [];
    listMachine[state.activeMachine] = ItemMachine(machine: listMachine[state.activeMachine].machine, listPathOper: list, time: listMachine[state.activeMachine].time);
    newList.addAll(listMachine);
    emit(state.copyWith(listMachine: []));
    emit(state.copyWith(listMachine: newList));
  }

  void getDown(){
    List<GroupOptPath> list = OperationsGroup().regroupDuwn(state.listMachine![state.activeMachine]);
    List<ItemMachine> listMachine = state.listMachine!;
    List<ItemMachine> newList = [];
    listMachine[state.activeMachine] = ItemMachine(machine: listMachine[state.activeMachine].machine, listPathOper: list, time: listMachine[state.activeMachine].time);
    newList.addAll(listMachine);
    emit(state.copyWith(listMachine: []));
    emit(state.copyWith(listMachine: newList));
  }

  void saver(List<GroupOptPath> list){
    List<OptPathOperations> listNew = [];
    for (var e in list) {
      listNew.addAll(e.listOptPath);
    }
    emit(state.copyWith(listSaver: listNew));
  }

  Future<void> saveDate() async {
    isActiveStream = false;
    emit(state.copyWith(isLoading: true));
    final tableOperations = OperatorOperationsTable();
    List<ItemSaver> saveList = [];
    for (var i = 0; i < state.listSaver.length; i++) {
      saveList.add(ItemSaver(idPath: state.listSaver[i].idPath, order: i));
    }
    for (var element in saveList) {
      await tableOperations.updateOrder(element.idPath, element.order);
    }
    isActiveStream = true;
    emit(state.copyWith(listSaver: [], isLoading: false));
  }

  // Future<void> saveDate(List<OptPathOperations> operList) async {
  //   List<ItemSaver> saveList = [];
  //   // final operList = state.listMachine![state.activePage].listOper;
  //   for (var i = 0; i < operList.length; i++) {
  //     // List<int> idL = [];
  //     // for (var oper in operList[i].list) {
  //     //   idL.add(oper.id);
  //     // }
  //     saveList.add(ItemSaver(idPath: operList[i].idPath, order: i));
  //   }
  //   for (var element in saveList) {
  //     await tableOperations.updateOrder(element.idPath, element.order);
  //   }
  // }
}