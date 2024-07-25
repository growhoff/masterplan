import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';
import 'package:master_plan/presentation/pages/master/widgets/dialog_saver.dart';

class NavbarMaster extends StatelessWidget {
  const NavbarMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMaster,StateMaster>(
      builder:(context, stateMaster) => GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) 
            {
              final user = state.user!;
              return Column(children: [
                Text(DataMaster.listPage[stateMaster.activePage].title), 
                Text('${user.fio} / ${user.position.name} / ${user.area!.name}', style: const TextStyle(fontSize: 12)),
              ]);
              }
              ),
            actions: DataMaster.listPage[stateMaster.activePage].actions,
          ),
          body: DataMaster.listPage[stateMaster.activePage].page,
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: stateMaster.activePage,
            height: 50,
            destinations: DataMaster.listPage.map((e) => NavigationDestination(icon: Icon(e.icon, color: Colors.black),label: e.title,)).toList(),
            onDestinationSelected: (value) {
              bool check = context.read<CubitMaster>().checkDialog(value);
              if (check) {
                showDialog(
                  context: context, 
                  builder: (BuildContext innerContext) {
                    return BlocProvider.value(value: context.watch<CubitMaster>(),
                    child: Material(
                        child: BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => const DialogSaver()),
                      ),
                    );
                  });
              }
              else {context.read<CubitMaster>().setPage(value);}
              }
          ),
        ),
      ),
    );
  }
}