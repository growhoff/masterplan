import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
// import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
// import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/state.dart';
import '../widgets/content_ready.dart';

class ElementBarReady extends StatelessWidget {
  const ElementBarReady({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitReadyDetailsChM, StateReadyDetailsChM>(
      builder:(context, state) => state.listMachine!.isNotEmpty && state.statusList.isNotEmpty
      ? Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => context.read<CubitReadyDetailsChM>().setActivePage(index),
                child: SizedBox(width: 200, child: Card(color: state.activePage == index ? Colors.blueGrey : const Color.fromARGB(0, 0, 0, 0), child: Center(child: Text(state.listMachine![index].machine.name, textAlign: TextAlign.center)))),
              ), 
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemCount: state.listMachine!.length),
          ),
            const SizedBox(height: 18),
            ContetnReadyMaster(l: state.statusList[state.activePage], operList: state.listMachine![state.activePage].listOper, machine: state.listMachine![state.activePage].machine, timeWorking: state.listMachine![state.activePage].time)
        ],
      )
      : const Center(child: CircularProgressIndicator()),
    );
  }
}