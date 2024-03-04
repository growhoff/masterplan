import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';

class NavBarCustom extends StatefulWidget {
  const NavBarCustom({super.key});

  @override
  State<NavBarCustom> createState() => _NavBarCustomState();
}

class _NavBarCustomState extends State<NavBarCustom> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(DataMaster.listPage[selectedIndex].title),
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