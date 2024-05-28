import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'state.dart';

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
    List<int> listId = [];
    for (var element in data!) {
      if ((element['status_id'] as int == 2) || (element['status_id'] as int == 4) || (element['status_id'] as int == 6)) listId.add(element['id']);
    }
    final table = OperatorOperationsTable();
    final quere = await table.selectListIdNew(listId);
    List<OperatorOperationsDTO> list = [];
    for (var item in quere) {
      list.add(OperatorOperationsDTO.fromMap(item));
    }
    // /*
    //
    List<DistribItem> listRes = [];
    List<OperatorOperationsDTO> listOperate = [];
    final tableChiefOper = ChiefOperationTable();
    Set<String> setList = {};
    for (var i = 0; i < list.length; i++) {
      setList.add('${list[i].chiefBatchId!}_${list[i].stageId}');
    }
    for (var setI in setList) {
      List<String> ids = setI.split('_');
      //парсим все операции по chief_batch_id и stage_id
      List<Map<String, dynamic>> queryOper = await tableChiefOper.selectId(int.parse(ids[0]),int.parse(ids[1]));
      //поочередно проходим по запросу и проверяем с массивом операций
      //ищем первую операцию из запроса, 
        //если она без статуса, тогда записываем, 
          //если у неё статус готово и дальше нет элементов, тогда пропуск, 
            //если элементы ещё есть, идём дальше и проверяем на готовый, иначе записываем 
      for (var itemQuery in queryOper) {
        List<OperatorOperationsDTO> listTrue = list.where((item) => itemQuery['id'] == item.chiefOperationId).toList();
        // listTrue.sort((a, b) => a.id.compareTo(b.id),);
        for (var itemTrue in listTrue) {
          if (itemTrue.statusId == 2 || itemTrue.statusId == 4) {listOperate.add(itemTrue); break;}


          // if (itemTrue.statusId == 6) break;
          //
          //Доработать по остальным статусам
          //
        }
      }
    }

    Set<String> setListRes = {};
    for (var i = 0; i < list.length; i++) {
      setListRes.add('${list[i].batchId}_${list[i].stageId}');
    }
    for (var sets in setListRes) {
      List<String> idSets = sets.split('_');
      List<OperatorOperationsDTO> listTrue = listOperate.where((el) => (int.parse(idSets[0]) == el.batchId) && (int.parse(idSets[1]) == el.stageId)).toList();
      listTrue.sort((a, b) => b.order!.compareTo(a.order!));
      if (listTrue.isNotEmpty) listRes.add(convertToDistrib(listTrue));
    }

    //
    // */

    // List<DistribItem> listItem = [];
    //   for (var operOperat in list) {
    //     listItem.add(DistribItem(id: operOperat.id, stageNumber: operOperat.stage!.number, statusId: operOperat.status.id, detailNumber: operOperat.batch.number, operationName: operOperat.operation.name, count: operOperat.batch.count, isSelected: false));
    //   }
    emit(state.copyWith(operList: listRes, isLoading: false));
  }

  DistribItem convertToDistrib(List<OperatorOperationsDTO> operOperat){
    return  DistribItem(id: operOperat.first.id, stageNumber: operOperat.first.stage!.number, statusId: operOperat.first.status.id, detailNumber: operOperat.first.batch.number, operationName: operOperat.first.operation.name, count: operOperat.first.batch.count, isSelected: false, listOperat: operOperat, timeSh: operOperat.first.operation.timeSH ?? 0, timePZ: operOperat.first.operation.timepz, setOptPart: 1);
  }

  void toggleSelect(int index){
    List<DistribItem> list = [...state.operList];
    DistribItem item = state.operList[index];
    bool select = state.operList[index].isSelected;
    final newitem = item.copyWith(isSelected: !select);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }

  void setMachine(int index, String machine){
    List<DistribItem> list = [...state.operList];
    DistribItem item = state.operList[index];
    final newitem = item.copyWith(setMachine: machine);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }

  void setCount(int index, String countStr){
      if (countStr == '') {countStr = '0';}
      int count = int.parse(countStr);
      if (count > state.operList[index].listOperat.length) {count = state.operList[index].listOperat.length;}
      List<DistribItem> list = [...state.operList];
      DistribItem item = state.operList[index];
      final newitem = item.copyWith(setCount: count);
      list.removeAt(index);
      list.insert(index,newitem);
      emit(state.copyWith(operList: list));
  }

  void setOptPath(int index, String countStr){
      if (countStr == '') {countStr = '1';}
      int count = int.parse(countStr);
      // if (count > state.operList[index].listOperat.length) {count = state.operList[index].listOperat.length;}
      List<DistribItem> list = [...state.operList];
      DistribItem item = state.operList[index];
      final newitem = item.copyWith(setOptPart: count);
      list.removeAt(index);
      list.insert(index,newitem);
      emit(state.copyWith(operList: list));
  }

  void updateOperation(){
    final table = OperatorOperationsTable();
    for (var oper in state.operList) {
      if ((oper.setCount != null) && (oper.setCount != 0) && (oper.setMachine != '')) {
        for (var machine in listMachine) {
          if (machine.name == oper.setMachine) {
            List<int> listId = [];
            for (var i = 0; i < oper.setCount!; i++) {
              listId.add(oper.listOperat[i].id); 
            }
            table.updateMasterQueueList(listId, machine.id);
              // table.updateMasterQueue(oper.id, machine.id);
            }
        }
      }
    }
  }
}