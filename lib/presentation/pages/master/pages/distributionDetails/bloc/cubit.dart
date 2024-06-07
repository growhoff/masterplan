import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/set_model.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/set_model_chief.dart';
import 'state.dart';
import 'package:collection/collection.dart';
import 'dart:math';

class CubitDistributionDetails extends Cubit<StateDistributionDetails> {
  final int areaIdUser;
  final List<Machine> listMachine;
  final tableOperations = OperatorOperationsTable();
  CubitDistributionDetails(this.areaIdUser, this.listMachine) : super(const StateDistributionDetails()){
      tableOperations.table.stream(primaryKey: ['id']).inFilter('area_id', [areaIdUser]).listen((event){
      }).onData((data)async {
          emit(state.copyWith(isLoading: true));
          await getQuere(data);
      });
  }

    Future<void> getQuere (List<Map<String, dynamic>>? data)async{
    // List<int> listId = [];
    Set<int> listId = {};
    for (var element in data!) {
      // if ((element['status_id'] as int == 2) || (element['status_id'] as int == 4) || (element['status_id'] as int == 6)) listId.add(element['id']);chief_batch_id
       if ((element['status_id'] as int == 2) || (element['status_id'] as int == 4) || (element['status_id'] as int == 6) || (element['status_id'] as int == 9)) listId.add(element['chief_batch_id']);
    }
    // final quere = await tableOperations.selectListIdOrder(listId);
    final quere = await tableOperations.selectListChiefBatchIdOrder(listId.toList());
    List<OperatorOperationsDTO> list = [];
    Set<int> setChiefBatchId = {};
    Set<int> setBatchId = {};
    Set<String> setAllId = {};
    for (var item in quere) {
      final model = OperatorOperationsDTO.fromMap(item);
      setChiefBatchId.add(model.chiefBatchId!);
      setBatchId.add(model.batchId);
      setAllId.add('${model.batchId}_${model.stageId}_${model.operationId}'); 
      list.add(model);
    }
    //лист с batch_id и operation_id по порядку
    var listSearch = await getChiefTable(setBatchId.toList());

    //группировка по деталям
    List<SetModelBatch> listModelBatch = [];
    for (var eSet in setChiefBatchId) {
      List<OperatorOperationsDTO> listCash = [];
      for (var eOper in list) {
        if (eSet == eOper.chiefBatchId) listCash.add(eOper);
      }
      listModelBatch.add(SetModelBatch(chiefBatchId: eSet, batchId: listCash.first.batchId, list: listCash));
    }

    //создание списка операций new
    List<OperatorOperationsDTO> listReady = [];
    //проход по каждой детали chiefBatchId
    for (var iModBatch in listModelBatch) {
      //проход по списку batchId
      for (var elSearch in listSearch) {
        //проход по операциям
        if (iModBatch.batchId == elSearch.batchId){
          // сравнение двух листо операций и order
          for (var order in elSearch.list) {
            bool next = false;
            for (var item in iModBatch.list) {
              if (item.operationId == order) {
                if ((item.statusId == 2 || item.statusId == 4) && item.areaId == areaIdUser) {listReady.add(item);break;}
                if (item.statusId == 6 || item.statusId == 9) next = true;
              }
            }
            if (!next) break;
          }
        }
      }
    }

    //группировка по операциям
    List<DistribItem> listResOper = [];
    for (var setI in setAllId) {
      final listName = setI.split('_');
      final batchId = listName[0];
      final stageId = listName[1];
      final operId = listName[2];
      //разделение на два массива с доработкой и на распределении
      List<OperatorOperationsDTO> listTrue2 = [];
      List<OperatorOperationsDTO> listTrue4 = [];
      for (var el in listReady) {
        if ((int.parse(batchId) == el.batchId) && (int.parse(stageId) == el.stageId) && (int.parse(operId) == el.operationId) && (el.statusId == 2)) listTrue2.add(el);
        if ((int.parse(batchId) == el.batchId) && (int.parse(stageId) == el.stageId) && (int.parse(operId) == el.operationId) && (el.statusId == 4)) listTrue4.add(el);
      }
      if (listTrue2.isNotEmpty) listResOper.add(convertToDistrib(listTrue2));
      if (listTrue4.isNotEmpty) listResOper.add(convertToDistrib(listTrue4));
    }
    emit(state.copyWith(operList: listResOper, isLoading: false));
  }


  //получение порядка операций у деталей
  Future<List<SetModelChief>> getChiefTable (List<int> listIdBatch)async{
    final tableChief = ChiefDistributionOperationsTable();
    final quereChief = await tableChief.selectListBatchId(listIdBatch);
    List<ChiefDistributionOperationsDTO> listChief = [];
    for (var element in quereChief) {
      listChief.add(ChiefDistributionOperationsDTO.fromMap(element));
    }
    List<SetModelChief> listB = [];
    var newMap = groupBy(listChief, (el) => el.batchId);
    newMap.forEach((key, value) {
      List<int> list = [];
      for (var element in value) {
        list.add(element.operationId);
      }
      listB.add(SetModelChief(batchId: key, list: list));
    });
    return listB;
  }


  DistribItem convertToDistrib(List<OperatorOperationsDTO> operOperat) {
    return DistribItem(
        id: operOperat.first.id,
        stageNumber: operOperat.first.stage!.number,
        statusId: operOperat.first.status.id,
        detailNumber: '${operOperat.first.batch.number} ${operOperat.first.batch.name}',
        operationName: '${operOperat.first.operation.number} ${operOperat.first.operation.name}',
        count: operOperat.length,
        isSelected: false,
        listOperat: operOperat,
        timeSh: operOperat.first.operation.timeSH ?? 0,
        timePZ: operOperat.first.operation.timepz,
        setOptPart: 1);
  }

  void toggleSelect(int index){
    List<DistribItem> list = [...state.pathListOper];
    DistribItem item = state.pathListOper[index];
    bool select = state.pathListOper[index].isSelected;
    final newitem = item.copyWith(isSelected: !select);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }

  void setMachine(int index, String machine){
    List<DistribItem> list = [...state.pathListOper];
    DistribItem item = state.pathListOper[index];
    final newitem = item.copyWith(setMachine: machine);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }

  void setCount(int index, String countStr){
      if (countStr == '') {countStr = '0';}
      int count = int.parse(countStr);
      if (count > state.pathListOper[index].listOperat.length) {count = state.pathListOper[index].listOperat.length;}
      List<DistribItem> list = [...state.pathListOper];
      DistribItem item = state.pathListOper[index];
      final newitem = item.copyWith(setCount: count);
      list.removeAt(index);
      list.insert(index,newitem);
      emit(state.copyWith(operList: list));
  }

  void setOptPath(int index, String countStr){
      if (countStr == '') {countStr = '1';}
      int count = int.parse(countStr);
      if (count > state.pathListOper[index].listOperat.length) {count = state.pathListOper[index].listOperat.length;}
      List<DistribItem> list = [...state.pathListOper];
      DistribItem item = state.pathListOper[index];
      final newitem = item.copyWith(setOptPart: count);
      list.removeAt(index);
      list.insert(index,newitem);
      emit(state.copyWith(operList: list));
  }

  int getRandom(){
    var rng = Random();
    return rng.nextInt(1000000);
  }

  void updateOperation(){
    for (var pathOper in state.pathListOper) {
      //проверяем заполнены ли поля
      if ((pathOper.setCount != null) && (pathOper.setCount != 0) && (pathOper.setMachine != '')) {
        //проходим по списку машин и сравниваем
        for (var machine in listMachine) {
          if (machine.name == pathOper.setMachine) {
            //считаем остаток
            final int countRemains = pathOper.setCount! % pathOper.setOptPart!;
            // final int countFull = pathOper.setCount! ~/ pathOper.setOptPart!;
            List<int> listId = [];
            List<OperatorOperationsDTO> list = pathOper.listOperat;
            if (pathOper.setCount == pathOper.setOptPart){
              //выгружаем нужное количество операций
              for (var i = 0; i < pathOper.setCount!; i++) {
                listId.add(list[i].id);
              }
              //меняем статус этих операций
              tableOperations.updateMasterQueueListPath(listId, machine.id, getRandom());
            } else{
              //если остатка нет
              if (countRemains == 0){
                //countFull
                for (var i = 0; i < pathOper.setCount!; i++) {
                  listId.add(list[i].id);
                  if ((listId.length) == pathOper.setOptPart) {
                    tableOperations.updateMasterQueueListPath(listId, machine.id, getRandom()); 
                    listId.clear();
                  }
                }
              }else{
                //countRemains
                final ll = list.getRange(0, countRemains).toList();
                for (var e in ll) {
                  listId.add(e.id);
                }
                list.removeRange(0, countRemains);
                tableOperations.updateMasterQueueListPath(listId, machine.id, getRandom());
                listId.clear();

                //countFull
                for (var i = 0; i < pathOper.setCount!-countRemains; i++) {
                  listId.add(list[i].id);
                  if ((listId.length) == pathOper.setOptPart) {
                    tableOperations.updateMasterQueueListPath(listId, machine.id, getRandom()); 
                    listId.clear();
                  }
                }
              }
            }
            
            
            // List<int> listId = [];
            //выгружаем нужное количество операций
            // for (var i = 0; i < pathOper.setCount!; i++) {
              // listId.add(pathOper.listOperat[i].id);
            // }
            //меняем статус этих операций
            // tableOperations.updateMasterQueueList(listId, machine.id);
          }
        }
      }
    }
  }
}