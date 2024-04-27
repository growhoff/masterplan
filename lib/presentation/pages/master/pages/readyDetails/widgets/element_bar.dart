import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/ready_details.dart';

class ElementBarReady extends StatelessWidget {
  const ElementBarReady({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitReadyDetails, StateReadyDetails>(
      builder:(context, state) => Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => context.read<CubitReadyDetails>().setActivePage(index),
                child: SizedBox(width: 200, child: Card(color: state.activePage == index ? Colors.blueGrey : const Color.fromARGB(0, 0, 0, 0), child: Center(child: Text(state.listMachine![index].machine.name)))),
              ), 
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemCount: state.listMachine!.length),
          ),
            const SizedBox(height: 18),
            ContetnReadyBrak(l: state.doubleList[state.activePage], operList: state.listMachine![state.activePage].listOper, machine: state.listMachine![state.activePage].machine, timeWorking: state.listMachine![state.activePage].time)
        ],
      ),
    );
  }
}