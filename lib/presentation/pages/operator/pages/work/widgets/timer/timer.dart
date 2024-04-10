import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/state.dart';
import '../buttonIcon.dart';

class Time extends StatelessWidget {
  const Time({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitTimer>(
        create: (context) => CubitTimer(context.read<CubitWork>().state.list.length), 
        child: const TimeContent(),
      );
  }
}

class TimeContent extends StatelessWidget {
  const TimeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitWork,StateWork>(
      builder:(context, stateWork) => BlocBuilder<CubitTimer, StateTimer>(
        builder:(context, state) => Column(
          children: [
                Text(state.listRes[stateWork.activePage], style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonCircleIcon(onPressed: () => context.read<CubitTimer>().refresh(stateWork.activePage), icon: Icons.restart_alt),
                    ButtonCircleIcon(
                      onPressed: () => !state.listState[stateWork.activePage] ? context.read<CubitTimer>().start(stateWork.activePage) : context.read<CubitTimer>().stop(stateWork.activePage), 
                      icon: !state.listState[stateWork.activePage] ? Icons.play_arrow_rounded : Icons.pause,
                      ),
                    ButtonCircleIcon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QueuePage(stateWork.pageData[stateWork.activePage].operList),)), icon: Icons.list),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}