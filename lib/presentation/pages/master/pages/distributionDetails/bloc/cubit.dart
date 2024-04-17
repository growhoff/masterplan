import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'state.dart';

class CubitDistributionDetails extends Cubit<StateDistributionDetails> {
  final List<OperatorOperations> operOperatList;
  final int areaIdUser;
  CubitDistributionDetails(this.operOperatList, this.areaIdUser) : super(const StateDistributionDetails()){
      List<DistribItem> list = [];
      for (var operOperat in operOperatList) {
        for (var stage in operOperat.batch.stageList) {
          for (var oper in stage.operationList) {
            //статус "на распределении" и регион у этапа совпадает с пользователем
            if ((operOperat.status.id == 4) && (stage.areaId == areaIdUser)) {
              list.add(DistribItem(stageNumber: '${stage.number}', detailNumber: '${operOperat.batch.number}', operationName: oper.name, count: operOperat.batch.count, isSelected: false));
            }
          }
        }
      }
    emit(state.copyWith(operList: list));
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
    int count = int.parse(countStr);
    List<DistribItem> list = [...state.operList];
    DistribItem item = state.operList[index];
    final newitem = item.copyWith(setCount: count);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }
}