import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'state.dart';

class CubitDrop extends Cubit<StateDrop> {
  final List<AreaMachine> listAreaMachine;
  CubitDrop(this.listAreaMachine) : super(const StateDrop()){
    List<NameIndex> listItemArea = [];
    if (listAreaMachine.isNotEmpty){
      for (var i = 0; i < listAreaMachine.length; i++) {
        listItemArea.add(NameIndex(name: listAreaMachine[i].area.name, index: i));
      }
    }
    emit(state.copyWith(listAreaMachine: listAreaMachine, listItemArea: listItemArea));
  }

  void setActiveArea(int index){
    emit(state.copyWith(activeArea: index, activeMachine: 0));
    refreshLists();
  }
  void setActiveMachine(int index){
    emit(state.copyWith(activeMachine: index));
  }

  void refreshLists() {
    List<NameIndex> listItemMachine = [];
    if (state.listAreaMachine.isNotEmpty) {
      if (state.activeArea != null) {
        final listMachine = state.listAreaMachine[state.activeArea!].listMachine;
        for (var j = 0; j < listMachine.length; j++) {
          listItemMachine.add(NameIndex(name: listMachine[j].name, index: j));
        }
      }
    }
    emit(state.copyWith(listItemMachine: listItemMachine));
  }
}