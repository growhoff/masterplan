import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

import '../data/chief_data.dart';

class NavBarCustomChief extends StatefulWidget {
  const NavBarCustomChief({super.key});

  @override
  State<NavBarCustomChief> createState() => _NavBarCustomChiefState();
}

class _NavBarCustomChiefState extends State<NavBarCustomChief> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
            final user = state.user!;
            return Column(
              children: [
                Text(DataChief.listPage[selectedIndex].title),
                Text(
                    ' ${user.fio} / ${user.position.name} / ${user.unit!.name}',
                    style: const TextStyle(fontSize: 12)),
              ],
            );
          }),
          actions: DataChief.listPage[selectedIndex].actions,
        ),
        body: DataChief.listPage[selectedIndex].page,
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: selectedIndex,
          height: 50,
          destinations: DataChief.listPage
              .map((e) => NavigationDestination(
                    icon: Icon(e.icon, color: Colors.black),
                    label: e.title,
                  ))
              .toList(),
          onDestinationSelected: (value) {
            selectedIndex = value;
            setState(() {});
          },
        ),
      ),
    );
  }
}
