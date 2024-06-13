import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
import '../data/data_master.dart';

class NavbarChiefMaster extends StatelessWidget {
  const NavbarChiefMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitChiefMaster,StateChiefMaster>(
      builder:(context, stateMaster) => GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) 
            {
              final user = state.user!;
              return Column(children: [
                Text(DataChiefMaster.listPage[stateMaster.activePage].title), 
                Text('${user.fio} / ${user.position.name} / Начальник-мастер', style: const TextStyle(fontSize: 12)),
              ]);
              }
              ),
            actions: DataChiefMaster.listPage[stateMaster.activePage].actions,
          ),
          body: DataChiefMaster.listPage[stateMaster.activePage].page,
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: stateMaster.activePage,
            height: 50,
            destinations: DataChiefMaster.listPage.map((e) => NavigationDestination(icon: Icon(e.icon, color: Colors.black),label: e.title,)).toList(),
            onDestinationSelected: (value) => context.read<CubitChiefMaster>().setPage(value),
          ),
        ),
      ),
    );
  }
}