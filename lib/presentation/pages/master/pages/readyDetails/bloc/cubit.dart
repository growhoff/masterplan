import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';
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
      listB.add(ItemOperReady(idPath: key!, list: list, listId: listId));
    });

    List<ItemMachine> listMachine = [];
    List<List<int>> doubleList = [];
    for (var machine in machineList!) {
      int timeWorking = 0;
      List<ItemOperReady> list = [];
      List<int> intList = [];
      for (var operList in listB) {
        if (operList.list.first.machine!.id == machine.id) {
          list.add(operList);

          // if (operList.timeworking == null){
          //   timeWorking += 0;
          // }else{
          //   timeWorking += operList.timeworking!;
          // }
          intList.add(6);
        }
      }
      listMachine.add(ItemMachine(machine: machine, listOper: list, time: timeWorking ~/ 60));
      doubleList.add(intList);
    }
    emit(state.copyWith(listMachine: listMachine, doubleList: doubleList));
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

  void toggleBrak(int indexOper){
    List<List<int>> l = [...state.doubleList];
    int it = l[state.activePage][indexOper];
    if (it == 5) {it = 6;} else {it = 5;}
    List<int> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, it);
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(doubleList: l, count: state.count+1));
  }
  

  void toggleModific(int indexOper){
    List<List<int>> l = [...state.doubleList];
    int it = l[state.activePage][indexOper];
    if (it == 4) {it = 6;} else {it = 4;}
    List<int> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, it);
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(doubleList: l, count: state.count+1));
  }

  Future<void> updateOperation() async{
    final table = OperatorOperationsTable();
    final chiefBatchTable = ChiefBatchTable();
    final listOper = state.listMachine![state.activePage].listOper;
    if (listOper.isNotEmpty) {
      final listStatus = state.doubleList[state.activePage];
      for (var i = 0; i < listOper.length; i++) {
        //доработка
        if (listStatus[i] == 4) table.updateMasterModificateList(listOper[i].listId);
        //брак
        if (listStatus[i] == 5) {
          //выгрузить все операции по chiefBatchId
          List<int> listChiefBatchId = [];
          for (var element in listOper[i].list) {
            listChiefBatchId.add(element.chiefBatchId!);
          }
          final quere = await tableOperations.selectChiefBatchIdList(listChiefBatchId);
          //получаем лист id нужных операций
          final listId = getListIdFromQueue(quere);
          //меняем статус по этим id в брак
          table.updateMasterBrakList([...listId,...listOper[i].listId]);
          chiefBatchTable.updateChiefBatchStatusToDefect(chiefBatchId: listOper[i].list.first.chiefBatchId ?? 0);
        }
        //готово
        if (listStatus[i] == 6) table.updateMasterStatisticReadyList(listOper[i].listId);
      }
    }
  }

  List<int> getListIdFromQueue(List<Map<String, dynamic>> data){
    List<int> list = [];
    for (var element in data) {
      if (element['status_id'] == 2 || element['status_id'] == 3 || element['status_id'] == 4) list.add(element['id']);
    }
    return list;
  }
}