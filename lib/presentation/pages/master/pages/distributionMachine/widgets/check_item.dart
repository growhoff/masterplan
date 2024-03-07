import 'package:flutter/material.dart';

class CheckItem extends StatefulWidget {
  const CheckItem(this.index, {super.key});
  final int index;
  @override
  State<CheckItem> createState() => _CheckItemState();
}

class _CheckItemState extends State<CheckItem> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black12,
      child: CheckboxListTile(
        shape: const BeveledRectangleBorder(side: BorderSide(color: Colors.black26)),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Этап № [stageNumber ${widget.index}]'),
              const Text('Операция № [operationNumber]'),
              const Text('[operationName]'),
              const Text('количество [1] / [2]')
            ],
          ),
        ),
        value: isCheck,
        onChanged: (value) {
          isCheck = value!;
          setState(() {});
        },
      ),
    );
  }
}