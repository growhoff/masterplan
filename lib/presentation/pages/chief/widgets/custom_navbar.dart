import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/chief/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/chief/bloc/state.dart';

import '../data/chief_data.dart';

class NavBarCustomChief extends StatelessWidget {
  const NavBarCustomChief({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitChief,StateChief>(
        builder:(context, stateMaster) => GestureDetector(
          child: Scaffold(
            appBar: AppBar(
              title: BlocBuilder<CubitMain, StateMain>(builder: (context, state)
              {
                final user = state.user!;
                return Column(children: [
                  Text(DataChief.listPage[stateMaster.activePage].title),
                  Text('${user.fio} / ${user.position.name} / ${user.unit!.name}', style: const TextStyle(fontSize: 12)),
                ]);
                }
                ),
              actions: stateMaster.activePage == 5 ? [IconButton(onPressed: () => context.read<CubitChief>().toggleMonitor(), icon: const Icon(Icons.transform_rounded, color: Colors.amber,))] : [const Text('')],
              // DataMaster.listPage[stateMaster.activePage].actions,
            ),
            body: DataChief.listPage[stateMaster.activePage].page,
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: stateMaster.activePage,
              height: 50,
              destinations: DataChief.listPage.map((e) => NavigationDestination(icon: Icon(e.icon, color: Colors.black),label: e.title,)).toList(),
              onDestinationSelected: (value) => context.read<CubitChief>().setPage(value)
            ),
          ),
        ),
      );
  }
}