import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/name_index.dart';
import '../bloc/cubit.dart';

class DropAreaChangeOper extends StatelessWidget {
  const DropAreaChangeOper(this.activeArea, this.listItemArea, {super.key});
  final int activeArea;
  final List<NameIndex> listItemArea;
  @override
  Widget build(BuildContext context) {
    return Container(
              decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
              child: DropdownButton<int>(
                isExpanded: true,
                underline: Container(),
                borderRadius: BorderRadius.circular(12),
                hint: const Text('Выберите участок'),
            
                value: activeArea,
                items: listItemArea.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name)),).toList(),
                selectedItemBuilder: (context) => listItemArea.map((e) => Center(child: Text(e.name),)).toList(),
                onChanged: (value) => value != null ? context.read<CubitChangeOperator>().setActiveArea(value) : null,
              ),
            );
  }
}