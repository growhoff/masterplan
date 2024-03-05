
import 'package:flutter/material.dart';

import 'reorderable_icon_widget.dart';

class ReorderWidget extends StatefulWidget {
  const ReorderWidget(this.list, {super.key, required this.header});
  final List<String> list;
  final Widget header;
  @override
  State<ReorderWidget> createState() => _ReorderWidgetState();
}

class _ReorderWidgetState extends State<ReorderWidget> {

  late List<String> list;

  @override
  void initState() {
    list = widget.list;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        // buildDefaultDragHandles: false,
        shrinkWrap: true,
        header: widget.header,
        itemBuilder: (context, index) => Row(
          key: ValueKey(index),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: ReorderableIconWidget(index)),
            Expanded(flex: 2, child: Text('[planNumber] $index')),
            Expanded(flex: 2, child: Text('[operationNumber] $index')),
            Expanded(flex: 2, child: Text('[operationTime] $index')),
            Expanded(child: IconButton(onPressed: () => list.removeAt(index), icon: const Icon(Icons.close)))
          ],
        ),
        itemCount: list.length, 
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {newIndex = newIndex - 1;}
          final element  = list.removeAt(oldIndex);
          list.insert(newIndex, element);
          setState(() {});
        }
      );
  }
}