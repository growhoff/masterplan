import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';

class NavBarCustomMaster extends StatefulWidget {
  const NavBarCustomMaster({super.key});
  
  @override
  State<NavBarCustomMaster> createState() => _NavBarCustomMasterState();
}

class _NavBarCustomMasterState extends State<NavBarCustomMaster> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) => Column(children: [
              Text(DataMaster.listPage[selectedIndex].title), 
              Text('${state.user.id} / ${state.user.fio} / ${state.user.position} / ${state.user.region}', style: const TextStyle(fontSize: 12)),
            ])),
          actions: DataMaster.listPage[selectedIndex].actions,
        ),
        body: DataMaster.listPage[selectedIndex].page,
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: selectedIndex,
          height: 50,
          destinations: DataMaster.listPage.map((e) => NavigationDestination(icon: Icon(e.icon, color: Colors.black),label: e.title,)).toList(),
          onDestinationSelected: (value) {
            selectedIndex = value;
            setState(() {});
          },
        ),
      ),
    );
  }
}