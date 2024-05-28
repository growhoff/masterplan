import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/state.dart';
import '../button_icon.dart';

class Time extends StatelessWidget {
  const Time({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitWork,StateWork>(
      builder:(context, stateWork) => BlocBuilder<CubitTimer, StateTimer>(
        builder:(context, state) => Column(
          children: [
                Text(state.listRes[stateWork.activePage], style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonCircleIcon(
                      isActive: (stateWork.statusBtn[stateWork.activePage] == 0) || (stateWork.statusBtn[stateWork.activePage] == 1),
                      onPressed: () {
                        context.read<CubitTimer>().startOrStop(stateWork.activePage, !state.listState[stateWork.activePage], stateWork.pageData[stateWork.activePage].operActive!.id);
                        // context.read<CubitWork>().setMonitor(0, context.read<CubitMain>().state.user!.id, 'start time', !state.listState[stateWork.activePage]);//доработать старт стоп
                        // context.read<CubitWork>().setBtnStatus(0);
                        context.read<CubitWork>().setStartMonitor(0,context.read<CubitMain>().state.user!.id, 'start time');
                      }, 
                      icon: !state.listState[stateWork.activePage] ? Icons.play_arrow_rounded : Icons.pause,
                      ),
                    ButtonCircleIcon(
                      isActive: (stateWork.statusBtn[stateWork.activePage] == 0) || (stateWork.statusBtn[stateWork.activePage] == 1),
                      onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => QueuePage(dataPage: stateWork.pageData[stateWork.activePage]))), 
                      icon: Icons.list),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}