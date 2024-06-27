import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/domain/model/status.dart';
// import '../model/item_area.dart';
import '../model/item_id.dart';
import '../model/item_machine.dart';
// import '../model/item_oper.dart';
import '../model/status_next.dart';
import '../../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import 'state.dart';
import 'package:collection/collection.dart';

class CubitReadyDetailsChM extends Cubit<StateReadyDetailsChM> { 
  // final List<Machine>? machineList;
  // final List<int> machineIdList;
  final List<AreaMachine> listAreaMachine;
  final tableOperations = OperatorOperationsTable();
  CubitReadyDetailsChM( this.listAreaMachine) : super(const StateReadyDetailsChM()){
    emit(state.copyWith(listAreaMachine: listAreaMachine));
    tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', listAreaMachine[state.activeArea].idListMachine).listen((event) {
      }).onData((data)async {
        await getQuere(data);
      });
  }

  Future<void> getQuere (List<Map<String, dynamic>>? data)async{
    List<int> listId = [];
    for (var element in data!) {
      if (element['status_id'] as int == 6) listId.add(element['id']);
    }
    final quere = await tableOperations.selectListIdOrder(listId);
    List<OperatorOperationsDTO> readyList = [];
    for (var item in quere) {
      readyList.add(OperatorOperationsDTO.fromMap(item));
    }

    List<OptPathOperations> listB = [];
    var newMap = groupBy(readyList, (el) => el.optimalPart);
    newMap.forEach((key, value) {
      List<OperatorOperations> list = [];
      List<int> listId = [];
      for (var element in value) {
        list.add(convertDto(element));
        listId.add(element.id);
      }
      listB.add(OptPathOperations(idPath: key!, list: list, listId: listId, time: list.first.timeworking ?? 0));
    });

    List<ItemMachine> listMachine = [];
    List<List<StatusNext>> statusList = [];
    for (var machine in listAreaMachine[state.activeArea].listMachine) {
      int timeWorking = 0;
      List<OptPathOperations> list = [];
      List<StatusNext> intList = [];
      for (var operList in listB) {
        if (operList.list.first.machine!.id == machine.id) {
          list.add(operList);
          timeWorking += operList.time;
          intList.add(StatusNext(status: 0, count: 1, comment: ''));
        }
      }
      listMachine.add(ItemMachine(machine: machine, listOper: list, time: timeWorking ~/ 60));
      statusList.add(intList);
    }
    //  List<ItemArea> listItemArea = [];
    //  List<List<StatusNext>> statusList = [];
    // for (var area in listAreaMachine) {
    //   List<ItemMachine> listItemMachine = [];
    //   List<StatusNext> intList = [];
    //   for (var machine in area.listMachine) {
    //     List<ItemOperReady> listQueue = [];
    //     int time = 0;
         
    //     for (var item in listB) {
    //       if (item.list.isNotEmpty && (item.list.first.machine!.id == machine.id)) {
    //         listQueue.add(item);
    //         // time +=item.time;
    //       }
    //     }
    //     listItemMachine.add(ItemMachine(machine: machine, listOper: listQueue, time: time));
        
    //   }
    // listItemArea.add(ItemArea(area: area.area, list: listItemMachine));statusList.add(intList);
    // }
    emit(state.copyWith(listMachine: listMachine, statusList: statusList));
  }

void setActiveMachine(int index) {
    emit(state.copyWith(activeMachine: index));
  }

  Future<void> setActiveArea(int index) async{
    emit(state.copyWith(activeArea: index, activeMachine: 0, listMachine: []));
    final quere = await tableOperations.selectListMachineId(state.listAreaMachine[index].idListMachine);
    await getQuere(quere);
  }

  OperatorOperations convertDto(OperatorOperationsDTO dto){
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
          chiefBatchId: dto.chiefBatchId,
          chiefOperationId: dto.chiefOperationId,
          optimalPart: dto.optimalPart,
          status: Status(id: dto.status.id, name: dto.status.name), 
          batch: Batch(id: dto.batch.id, number: dto.batch.number, name: dto.batch.name, count: dto.batch.count, code: dto.batch.code, orderId: dto.batch.orderId, technology: dto.batch.technology, order: dto.batch.order, isready: dto.batch.isready),
          order: dto.order, 
          machine: Machine(id: dto.machine!.id, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.areaId),
          );
  }

  // void setActivePage(int index){
  //   emit(state.copyWith(activePage: index));
  // }

  void toggleBrak(int indexOper, String countStr, String comment){
    int count = int.parse(countStr);
    int length = state.listMachine![state.activePage].listOper[indexOper].list.length;
    if (count > length) {count = length;}
    if (count < 0) {count = 0;}
    List<List<StatusNext>> l = [...state.statusList];
    int it = l[state.activePage][indexOper].status;
    if (it == 0 || it == 2) {it = 1;} else {it = 0;}
    List<StatusNext> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, StatusNext(status: it, count: count, comment: comment));
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(statusList: l, count: state.count+1));
  }
  

void toggleModific(int indexOper, String countStr, String comment){
    int count = int.parse(countStr);
    int length = state.listMachine![state.activePage].listOper[indexOper].list.length;
    if (count > length) {count = length;}
    if (count < 0) {count = 0;}
    List<List<StatusNext>> l = [...state.statusList];
    int it = l[state.activePage][indexOper].status;
    if (it == 0 || it == 1) {it = 2;} else {it = 0;}
    List<StatusNext> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, StatusNext(status: it, count: count, comment: comment));
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(statusList: l, count: state.count+1));
  }

  // Future<void> updateOperation() async{
  //   final table = OperatorOperationsTable();
  //   final chiefBatchTable = ChiefBatchTable();
  //   final listOper = state.listMachine![state.activePage].listOper;
  //   if (listOper.isNotEmpty) {
  //     final listStatus = state.statusList[state.activePage];
  //     for (var i = 0; i < listOper.length; i++) {
        
  //       //доработка
  //       if (listStatus[i].status == 2) {
  //         List<int> listSt2 = [];
  //         List<int> listSt0 = [];
  //         int count = listStatus[i].count;
  //         for (var e in listOper[i].listId!) {
  //           if (count == 0) {listSt0.add(e);}
  //           else{
  //             listSt2.add(e);
  //             count --;
  //           }
  //         }
  //         table.updateMasterModificateListCount(listSt2, listSt0, listStatus[i].comment);
  //       }

  //       //брак
  //       if (listStatus[i].status == 1) {
  //         //выгрузить все операции по chiefBatchId
  //         // List<int> listChiefBatchId = [];
  //         // for (var element in listOper[i].list) {
  //         //   listChiefBatchId.add(element.chiefBatchId!);
  //         // }
  //         // final quere = await tableOperations.selectChiefBatchIdList(listChiefBatchId);
  //         // //получаем лист id нужных операций
  //         // final listId = getListIdFromQueue(quere);

  //         List<int> listSt1 = [];
  //         List<int> listSt0 = [];
  //         int count = listStatus[i].count;
          
  //         for (var j = 0; j < listOper[i].list.length; j++) {
  //           if (count == 0){listSt0.add(listOper[i].listId![j]);} 
  //           else{
  //             // for (var e in listId[j].list) {
  //             //   listSt1.add(e);
  //             // }
  //             listSt1.add(listOper[i].listId![j]);
  //             count--;
  //           }
  //         }
  //         //меняем статус по этим id в брак
  //         table.updateMasterBrakListCount(listSt1, listSt0, listStatus[i].comment);
  //         List<OperatorOperations> chOperId = listOper[i].list.getRange(0, count).toList();
  //         List<int> chId = [];
  //         for (var e in chOperId) {
  //           chId.add(e.chiefBatchId!);
  //         }
  //         chiefBatchTable.updateChiefBatchStatusToDefectList(chiefBatchId: chId);
  //       }

  //       //готово
  //       if (listStatus[i].status == 0) table.updateMasterStatisticReadyList(listOper[i].listId!);
  //     }
  //   }
  // }

   Future<void> updateOperation() async{
    final table = OperatorOperationsTable();
    final chiefBatchTable = ChiefBatchTable();
    final listOper = state.listMachine![state.activePage].listOper;
    if (listOper.isNotEmpty) {
      final listStatus = state.statusList[state.activePage];
      final List<int> listIdStatusReady = [];
      // final List<int> listIdStatusModific = [];
      // final List<int> listIdStatusBrak = [];
      for (var i = 0; i < listOper.length; i++) {
        
        //доработка
        if (listStatus[i].status == 2) {
          List<int> listSt2 = [];
          // List<int> listSt0 = [];
          int count = listStatus[i].count;
          for (var e in listOper[i].listId!) {
            if (count == 0) {listIdStatusReady.add(e);}
            else{
              listSt2.add(e);
              count --;
            }
          }
          table.updateMasterModificateListCount(listSt2, listStatus[i].comment);
        }

        //брак
        if (listStatus[i].status == 1) {
          //выгрузить все операции по chiefBatchId
          // List<int> listChiefBatchId = [];
          // for (var element in listOper[i].list) {
          //   listChiefBatchId.add(element.chiefBatchId!);
          // }
          // final quere = await tableOperations.selectChiefBatchIdList(listChiefBatchId);
          // //получаем лист id нужных операций
          // final listId = getListIdFromQueue(quere);

          List<int> listSt1 = [];
          // List<int> listSt0 = [];
          int count = listStatus[i].count;
          
          for (var j = 0; j < listOper[i].list.length; j++) {
            if (count == 0){listIdStatusReady.add(listOper[i].listId![j]);} 
            else{
              // for (var e in listId[j].list) {
              //   listSt1.add(e);
              // }
              listSt1.add(listOper[i].listId![j]);
              count--;
            }
          }
          //меняем статус по этим id в брак
          table.updateMasterBrakListCount(listSt1, listStatus[i].comment);
          List<OperatorOperations> chOperId = listOper[i].list.getRange(0, listStatus[i].count).toList();
          List<int> chId = [];
          for (var e in chOperId) {
            chId.add(e.chiefBatchId!);
          }
          chiefBatchTable.updateChiefBatchStatusToDefectList(chiefBatchId: chId);
        }

        //готово
        if (listStatus[i].status == 0) listIdStatusReady.addAll(listOper[i].listId!); 
      }
      //тут выгрузка
      table.updateMasterStatisticReadyList(listIdStatusReady);
    }
  }

  List<ItemId> getListIdFromQueue(List<Map<String, dynamic>> data){
    List<ItemId> listB = [];
    var newMap = groupBy(data, (el) => el['chief_batch_id']);
    newMap.forEach((key, value) {
      List<int> listId = [];
      for (var element in value) {
        if (element['status_id'] == 2 || element['status_id'] == 3 || element['status_id'] == 4) listId.add(element['id']);
      }
      listB.add(ItemId(list: listId, idBatchId: key));
    });

    return listB;
  }
}