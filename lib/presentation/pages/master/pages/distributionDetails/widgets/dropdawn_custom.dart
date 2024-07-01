
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';

class DropdownButtonCustom extends StatefulWidget {
  const DropdownButtonCustom(this.listItem, this.index, {super.key});
  final List<String> listItem;
  final int index;
  @override
  State<DropdownButtonCustom> createState() => _DropdownButtonCustomState();
}

class _DropdownButtonCustomState extends State<DropdownButtonCustom> {

  late List<String> listItem;
  String? activeValue;
  late int indexMachine;

  @override
  void initState() {
    listItem = widget.listItem;
    indexMachine = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        isExpanded: true,
        underline: Container(),
        borderRadius: BorderRadius.circular(12),
        value: activeValue,
        hint: const Text('Выберите станок'),
        items: listItem.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
        selectedItemBuilder: (context) => listItem.map((e) => Center(child: Text(e),)).toList(),
        onChanged: (value){
          activeValue = value;
          setState(() {});
          if (value != null){ context.read<CubitDistributionDetails>().setMachine(indexMachine, value);}
        }),
    );
  }
}