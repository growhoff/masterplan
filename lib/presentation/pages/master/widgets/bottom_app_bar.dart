import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';

class BottomAppBarCastom extends StatelessWidget {
  const BottomAppBarCastom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
            child: TabBar(tabs: DataMaster.tabs.map((Widget el) => el).toList()),
          );
  }
}