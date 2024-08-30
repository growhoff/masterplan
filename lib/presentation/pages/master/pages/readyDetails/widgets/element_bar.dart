import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/content_ready.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/drop_area.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/drop_machine.dart';

class ElementBarReady extends StatelessWidget {
  const ElementBarReady({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitReadyDetails, StateReadyDetails>(
      builder:(context, state) => 
      
      state.listItemMachine.isNotEmpty
      ? Column(
        children: [
            Visibility(
              visible: state.listAreaMachine.length > 1,
              child: DropAreaReady(state.activeArea, state.listItemArea),
            ),
            const SizedBox(height: 8),
            DropMachineReady(state.activeMachine, state.listItemMachine),
            const SizedBox(height: 18),
            state.listMachine!.isNotEmpty
            ? 
              state.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ContetnReadyMaster(l: state.statusList[state.activeMachine], operList: state.listMachine![state.activeMachine].listOper, machine: state.listMachine![state.activeMachine].machine, timeWorking: state.listMachine![state.activeMachine].time)
            : const Center(child: CircularProgressIndicator())
        ],
      )
      : const Center(child: Text('Нет станков')),
    );
  }
}