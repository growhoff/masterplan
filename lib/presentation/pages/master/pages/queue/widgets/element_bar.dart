import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/bloc/state.dart';
import 'contetn_queue.dart';

class ElementBarQueue extends StatelessWidget {
  const ElementBarQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitQueueMaster, StateQueueMaster>(
      builder:(context, state) => state.listMachine!.isNotEmpty 
      ? Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => context.read<CubitQueueMaster>().setActivePage(index),
                child: SizedBox(width: 200, child: Card(color: state.activePage == index ? Colors.blueGrey : const Color.fromARGB(0, 0, 0, 0), child: Center(child: Text(state.listMachine![index].machine.name)))),
              ), 
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemCount: state.listMachine!.length),
          ),
            const SizedBox(height: 18),
            ContetnQueue(batchListQueue: state.listMachine![state.activePage].listOper, machine: state.listMachine![state.activePage].machine, timeWorking: state.listMachine![state.activePage].time)
        ],
      )
      : const Center(child: CircularProgressIndicator()),
    );
  }
}