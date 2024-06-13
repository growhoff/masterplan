import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
// import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/cubit.dart';
// import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/state.dart';
import '../monitoring_page.dart';

class ElementBarMonitor extends StatelessWidget {
  const ElementBarMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMonitoringChM, StateMonitoringChM>(
      builder:(context, state) => state.listBar!.isNotEmpty 
      ? Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => context.read<CubitMonitoringChM>().setActivePage(index),
                child: SizedBox(width: 200, child: Card(color: state.activePage == index ? Colors.blueGrey : const Color.fromARGB(0, 0, 0, 0), child: Center(child: Text(state.listBar![index].machine.name, textAlign: TextAlign.center)))),
              ), 
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemCount: state.listBar!.length),
          ),
            const SizedBox(height: 18),
            ContentListWidgetMasterChM(state.listBar![state.activePage], state.change)
        ],
      )
      : const Center(child: CircularProgressIndicator()),
    );
  }
}