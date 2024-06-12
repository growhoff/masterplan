import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_id.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/status_next.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import 'state.dart';
import 'package:collection/collection.dart';

class CubitReadyDetails extends Cubit<StateReadyDetails> { 
  final List<Machine>? machineList;
  final List<int> machineIdList;
  final tableOperations = OperatorOperationsTable();
  CubitReadyDetails(this.machineList, this.machineIdList) : super(const StateReadyDetails()){

    tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', machineIdList).listen((event) {
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

    List<ItemOperReady> listB = [];
    var newMap = groupBy(readyList, (el) => el.optimalPart);
    newMap.forEach((key, value) {
      List<OperatorOperations> list = [];
      List<int> listId = [];
      for (var element in value) {
        list.add(convertDto(element));
        listId.add(element.id);
      }
      listB.add(ItemOperReady(idPath: key!, list: list, listId: listId, timeWorking: list.first.timeworking ?? 0));
    });

    List<ItemMachine> listMachine = [];
    List<List<StatusNext>> statusList = [];
    for (var machine in machineList!) {
      int timeWorking = 0;
      List<ItemOperReady> list = [];
      List<StatusNext> intList = [];
      for (var operList in listB) {
        if (operList.list.first.machine!.id == machine.id) {
          list.add(operList);
          timeWorking += operList.timeWorking;
          intList.add(StatusNext(status: 0, count: 1));
        }
      }
      listMachine.add(ItemMachine(machine: machine, listOper: list, time: timeWorking ~/ 60));
      statusList.add(intList);
    }
    emit(state.copyWith(listMachine: listMachine, statusList: statusList));
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

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }

  void toggleBrak(int indexOper, String countStr){
    int count = int.parse(countStr);
    int length = state.listMachine![state.activePage].listOper[indexOper].list.length;
    if (count > length) {count = length;}
    if (count < 0) {count = 0;}
    List<List<StatusNext>> l = [...state.statusList];
    int it = l[state.activePage][indexOper].status;
    if (it == 0 || it == 2) {it = 1;} else {it = 0;}
    List<StatusNext> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, StatusNext(status: it, count: count));
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(statusList: l, count: state.count+1));
  }
  

void toggleModific(int indexOper, String countStr){
    int count = int.parse(countStr);
    int length = state.listMachine![state.activePage].listOper[indexOper].list.length;
    if (count > length) {count = length;}
    if (count < 0) {count = 0;}
    List<List<StatusNext>> l = [...state.statusList];
    int it = l[state.activePage][indexOper].status;
    if (it == 0 || it == 1) {it = 2;} else {it = 0;}
    List<StatusNext> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, StatusNext(status: it, count: count));
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(statusList: l, count: state.count+1));
  }


  Future<void> updateOperation() async{
    final table = OperatorOperationsTable();
    final chiefBatchTable = ChiefBatchTable();
    final listOper = state.listMachine![state.activePage].listOper;
    if (listOper.isNotEmpty) {
      final listStatus = state.statusList[state.activePage];
      for (var i = 0; i < listOper.length; i++) {
        
        //доработка
        if (listStatus[i].status == 2) {
          List<int> listSt2 = [];
          List<int> listSt0 = [];
          int count = listStatus[i].count;
          for (var e in listOper[i].listId) {
            if (count == 0) {listSt0.add(e);}
            else{
              listSt2.add(e);
              count --;
            }
          }
          table.updateMasterModificateListCount(listSt2, listSt0);
        }

        //брак
        if (listStatus[i].status == 1) {
          //выгрузить все операции по chiefBatchId
          List<int> listChiefBatchId = [];
          for (var element in listOper[i].list) {
            listChiefBatchId.add(element.chiefBatchId!);
          }
          final quere = await tableOperations.selectChiefBatchIdList(listChiefBatchId);
          //получаем лист id нужных операций
          final listId = getListIdFromQueue(quere);

          List<int> listSt1 = [];
          List<int> listSt0 = [];
          int count = listStatus[i].count;
          
          for (var j = 0; j < listOper[i].list.length; j++) {
            if (count == 0){

              listSt0.add(listOper[i].listId[j]);
            } else{
              for (var e in listId[j].list) {
                listSt1.add(e);
              }
              listSt1.add(listOper[i].listId[j]);
              count--;
            }
          }
          //меняем статус по этим id в брак
          table.updateMasterBrakListCount(listSt1, listSt0);
          List<int> chId = listChiefBatchId.getRange(0, count).toList();
          chiefBatchTable.updateChiefBatchStatusToDefectList(chiefBatchId: chId);
        }

        //готово
        if (listStatus[i].status == 0) table.updateMasterStatisticReadyList(listOper[i].listId);
      }
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