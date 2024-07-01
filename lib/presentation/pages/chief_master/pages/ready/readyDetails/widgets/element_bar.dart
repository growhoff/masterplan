import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
import '../widgets/content_ready.dart';
import 'package:master_plan/domain/model/name_index.dart';


class ElementBarReady extends StatelessWidget {
  const ElementBarReady({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitReadyDetailsChM, StateReadyDetailsChM>(
      builder:(context, state) {
        List<NameIndex> listItemArea = [];
        List<NameIndex> listItemMachine = [];
        if (state.listAreaMachine.isNotEmpty){
          for (var i = 0; i < state.listAreaMachine.length; i++) {
            listItemArea.add(NameIndex(name: state.listAreaMachine[i].area.name, index: i));
          }

          if (listItemArea.isNotEmpty){
            var listMachine = state.listAreaMachine[state.activeArea].listMachine;
            for (var i = 0; i < listMachine.length; i++) {
              listItemMachine.add(NameIndex(name: listMachine[i].name, index: i));
            }
        }
        }
        return state.listAreaMachine.isNotEmpty && state.statusList.isNotEmpty
      ? Column(
        children: [
            Container(
              decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
              child: DropdownButton<int>(
                isExpanded: true,
                underline: Container(),
                borderRadius: BorderRadius.circular(12),
                hint: const Text('Выберите участок'),
            
                value: state.activeArea,
                items: listItemArea.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name)),).toList(),
                selectedItemBuilder: (context) => listItemArea.map((e) => Center(child: Text(e.name),)).toList(),
                onChanged: (value) => value != null ? context.read<CubitReadyDetailsChM>().setActiveArea(value) : null,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
              child: DropdownButton<int>(
                isExpanded: true,
                underline: Container(),
                borderRadius: BorderRadius.circular(12),
                hint: const Text('Выберите станок'),
            
                value: state.activeMachine, 
                items: listItemMachine.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name)),).toList(),
                selectedItemBuilder: (context) => listItemMachine.map((e) => Center(child: Text(e.name),)).toList(),
                onChanged: (value) => value != null ? context.read<CubitReadyDetailsChM>().setActiveMachine(value) : null,
              ),
            ),
            const SizedBox(height: 20),
            state.listMachine!.isNotEmpty && state.statusList.isNotEmpty 
            ? ContetnReadyMaster(l: state.statusList[state.activeMachine], operList: state.listMachine![state.activeMachine].listOper, machine: state.listMachine![state.activeMachine].machine, timeWorking: state.listMachine![state.activeMachine].time)
            : const Center(child: CircularProgressIndicator())
        ],
      )
      : const Center(child: Text('Список пуст'));
      }
    );
  }
}