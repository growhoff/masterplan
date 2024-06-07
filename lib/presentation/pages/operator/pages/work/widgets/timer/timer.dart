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
    final userId = context.read<CubitMain>().state.user!.id;
    return BlocBuilder<CubitWork,StateWork>(
      builder:(context, stateWork) {
        final activePage = stateWork.activePage;
        final statusBtn = stateWork.statusBtn[activePage];
        final operActive = stateWork.pageData[stateWork.activePage].operActive!;
        return BlocBuilder<CubitTimer, StateTimer>(
        builder:(context, state) => Column(
          children: [
                Text(state.listRes[stateWork.activePage], style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonCircleIcon(
                      isActive: (statusBtn == 0) || (statusBtn == 1),
                      onPressed: () {
                        if (operActive.pause == null) {
                          context.read<CubitTimer>().firstStart(activePage, operActive.idPath);
                          context.read<CubitWork>().setStartMonitor(0, userId, 'start', operActive.idPath);
                          }
                        else {context.read<CubitTimer>().startOrStop(activePage, !state.listState[activePage], operActive.idPath, userId);}
                        
                      }, 
                      icon: !state.listState[activePage] ? Icons.play_arrow_rounded : Icons.pause,
                      ),
                    ButtonCircleIcon(
                      isActive: (statusBtn == 0) || (statusBtn == 1),
                      onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => QueuePage(dataPage: stateWork.pageData[activePage]))), 
                      icon: Icons.list),
                  ],
                ),
          ],
        ),
      );
      }
    );
  }
}