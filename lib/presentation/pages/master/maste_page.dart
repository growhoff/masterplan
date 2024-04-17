import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
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
                      BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => Expanded(flex: 5, child: ElevatedButton(onPressed: () => context.read<CubitMaster>().setChange(1), style: ElevatedButton.styleFrom(backgroundColor: state.change == 1 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('1 смена')))),
                      const Spacer(),
                      BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => Expanded(flex: 5,child: ElevatedButton(onPressed: () => context.read<CubitMaster>().setChange(2), style: ElevatedButton.styleFrom(backgroundColor: state.change == 2 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('2 смена'))))
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CubitMaster, StateMaster>(builder: (context2, stateMaster) => 
                    BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                      List<ZShiftsDistributionDTO> list = [];
                      for (var machine in state.area!.machineList){
                        bool iswr = false;
                        for (var shiftsDistr in state.zShiftsDistributionList!) {
                          if ((shiftsDistr.machine!.id == machine.id) && (shiftsDistr.change!.number == stateMaster.change)) {list.add(shiftsDistr); iswr = true;}
                        }
                        if (!iswr) {list.add(ZShiftsDistributionDTO(id: -1, date: DateTime.now(), user: UserDTO(position: PositionDTO(id: 0, name: ''), company: CompanyDTO.init(), id: 0, fio: 'none', companyId: 0, positionId: 0), machine: MachineDTO(id: machine.id, inventoryNumber: machine.inventoryNumber, name: machine.name), change: null, changeId: -1, machineId: -1, userId: -1));}
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
