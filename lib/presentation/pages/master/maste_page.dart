import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto2/change_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/widgets/change_list_operator.dart';
import 'widgets/calendar.dart';

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitMaster>(
      create: (context) => CubitMaster(),
      child: const MasterContent(),
    );
  }
}

class MasterContent extends StatelessWidget {
  const MasterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [  
                  
                  const Card(child: Calendar()),
                  const SizedBox(height: 8),
                  const Text('Распределение на станки'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => ElevatedButton(onPressed: () => context.read<CubitMaster>().setChange(1), style: ElevatedButton.styleFrom(backgroundColor: state.change == 1 ? Colors.blue : Colors.blueGrey), child: const Text('1 смена'))),
                      BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => ElevatedButton(onPressed: () => context.read<CubitMaster>().setChange(2), style: ElevatedButton.styleFrom(backgroundColor: state.change == 2 ? Colors.blue : Colors.blueGrey), child: const Text('2 смена')))
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CubitMaster, StateMaster>(builder: (context2, state2) => 
                    BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                      List<ZShiftsDistributionDTO2> list = [];
                      for (var machine in state.area!.machineList){
                        bool iswr = false;
                        for (var shiftsDistr in state.zShiftsDistributionList!) {
                          if ((shiftsDistr.machineId.id == machine.id) && (shiftsDistr.changeId.number == state2.change)) {list.add(shiftsDistr); iswr = true;}
                        }
                        if (!iswr) {list.add(ZShiftsDistributionDTO2(id: -1,changeId: ChangeDTO2.init(), date: DateTime.now(), userId: UserDTO2.init(), machineId: MachineDTO2(id: machine.id, inventoryNumber: machine.inventoryNumber, name: machine.name)));}
                      }
                      return ChangeListOperator(list);
                    }),
                  ),
                ],
              ),
              ),
          ),
        );
  }
}
