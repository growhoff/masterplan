import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';

class ElementBar extends StatefulWidget {
  const ElementBar({super.key, required this.list});
  final List<ElementBarData> list;
  @override
  State<ElementBar> createState() => _ElementBarState();
}

class _ElementBarState extends State<ElementBar> {

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                activeIndex = index;
                setState(() {});
              },
              child: SizedBox(width: 200, child: Card(color: activeIndex == index ? Colors.blueGrey : const Color.fromARGB(0, 0, 0, 0), child: Center(child: Text(widget.list[index].header)))),
            ), 
            separatorBuilder: (context, index) => const SizedBox(width: 5),
            itemCount: widget.list.length),
        ),
          const SizedBox(height: 18),
          widget.list[activeIndex].content
      ],
    );
  }
}