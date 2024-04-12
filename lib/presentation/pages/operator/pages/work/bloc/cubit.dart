import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/operator/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/machine_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/content_details.dart';
import 'state.dart';

class CubitWork extends Cubit<StateWork> {
  final List<ZShiftsDistributionDTO>? zShiftsDistributionList;
  final List<OperatorOperations>? operatorOperationsList;

  CubitWork(this.zShiftsDistributionList, this.operatorOperationsList) : super(const StateWork()) {
    List<ElementBarDataOperator> list = [];
    List<MachineItem> machineList = [];
    List<PageItem>? pageData = [];

    for (var shiftsDistr in zShiftsDistributionList!) {
      List<OperatorOperations> listOper = [];
      Machine machine = Machine(
          id: shiftsDistr.machine.id,
          inventoryNumber: shiftsDistr.machine.inventoryNumber,
          name: shiftsDistr.machine.name);
      for (var operList in operatorOperationsList!) {
        if (shiftsDistr.machine.id == operList.machine.id) {
          listOper.add(operList);
        }
      }
      machineList.add(MachineItem(machine: machine, operList: listOper));
      pageData.add(PageItem(machine: machine, operList: listOper, time: 0));
    }
    for (var i = 0; i < machineList.length; i++) {
      list.add(ElementBarDataOperator(header: machineList[i].machine.name, content: const ContentDetail()));
    }
    emit(state.copyWith(list: list, pageData: pageData));
  }

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }
}