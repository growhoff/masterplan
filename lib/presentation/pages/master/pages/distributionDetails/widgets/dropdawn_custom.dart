
import 'package:flutter/material.dart';

class DropdownButtonCustom extends StatefulWidget {
  const DropdownButtonCustom(this.listItem, {super.key});
  final List<String> listItem;
  @override
  State<DropdownButtonCustom> createState() => _DropdownButtonCustomState();
}

class _DropdownButtonCustomState extends State<DropdownButtonCustom> {

  late List<String> listItem;
  String? activeValue;

  @override
  void initState() {
    listItem = widget.listItem;
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
        hint: const Text('Выберите значение'),
        items: listItem.map((e) => DropdownMenuItem(value: e, child: Text(e)),).toList(),
        selectedItemBuilder: (context) => listItem.map((e) => Center(child: Text(e),)).toList(),
        onChanged: (value){
          activeValue = value;
          setState(() {});
        }),
    );
  }
}