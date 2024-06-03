import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
// import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/status.dart';
// import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import 'state.dart';

class CubitReadyDetails extends Cubit<StateReadyDetails> { 
  final List<Machine>? machineList;
  // final List<OperatorOperations>? readyList;
  final List<int> machineIdList;
  final tableOperations = OperatorOperationsTable();
  CubitReadyDetails(this.machineList, this.machineIdList) : super(const StateReadyDetails()){

    tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', machineIdList).listen((event) {
      }).onData((data)async {
        await getQuere(data);
          // List<ItemMachine> res = [];
          // res = [...await getQuere(data)];
          // emit(state.copyWith(listMachine: res));
      });

    // List<ItemMachine> listMachine = [];
    // List<List<int>> doubleList = [];
    // for (var machine in machineList!) {
    //   int timePlan = 0;
    //   List<OperatorOperations> list = [];
    //   List<int> intList = [];
    //   for (var operList in readyList!) {
    //     if (operList.machine!.id == machine.id) {
    //       list.add(operList);
    //       timePlan += operList.timeplan;
    //       intList.add(6);
    //     }
    //   }
    //   listMachine.add(ItemMachine(machine: machine, listOper: list, time: timePlan));
    //   doubleList.add(intList);
    // }
    // emit(state.copyWith(listMachine: listMachine, doubleList: doubleList));
  }

  
  Future<void> getQuere (List<Map<String, dynamic>>? data)async{
    List<int> listId = [];
    for (var element in data!) {
      if (element['status_id'] as int == 6) listId.add(element['id']);
    }
    final quere = await tableOperations.selectListIdNew(listId);
    List<OperatorOperationsDTO> readyList = [];
    for (var item in quere) {
      readyList.add(OperatorOperationsDTO.fromMap(item));
    }

    List<ItemMachine> listMachine = [];
    List<List<int>> doubleList = [];
    for (var machine in machineList!) {
      int timePlan = 0;
      List<OperatorOperations> list = [];
      List<int> intList = [];
      for (var operList in readyList) {
        if (operList.machine!.id == machine.id) {
          list.add(convertDto(operList));
          // timePlan += operList.timeplan;
          if (operList.timeplan == null){
            timePlan += 0;
          }else{
            timePlan += operList.timeplan!;
          }
          intList.add(6);
        }
      }
      listMachine.add(ItemMachine(machine: machine, listOper: list, time: timePlan));
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
          status: Status(id: dto.status.id, name: dto.status.name), 
          batch: Batch(id: dto.batch.id, number: dto.batch.number, name: dto.batch.name, count: dto.batch.count, code: dto.batch.code, packageId: dto.batch.packageId, technology: dto.batch.technology, order: dto.batch.order, isready: dto.batch.isready),
          // user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), 
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

  void updateOperation() {
    final table = OperatorOperationsTable();
    final chiefBatchTable = ChiefBatchTable();
    final listOper = state.listMachine![state.activePage].listOper;
    if (listOper.isNotEmpty) {
      final listStatus = state.doubleList[state.activePage];
      for (var i = 0; i < listOper.length; i++) {
        if (listStatus[i] == 4) table.updateMasterModificate(listOper[i].id);
        if (listStatus[i] == 5) {
          table.updateMasterBrak(listOper[i].id);
          chiefBatchTable.updateChiefBatchStatusToDefect(
              chiefBatchId: listOper[i].chiefBatchId ?? 0);
        }
        if (listStatus[i] == 6)
          table.updateMasterStatisticReady(listOper[i].id);
      }
    }
  }
}