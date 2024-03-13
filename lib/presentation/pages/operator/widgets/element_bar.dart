import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/operator/model/element_bar_data.dart';
// import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';

class ElementBarOperator extends StatefulWidget {
  const ElementBarOperator({super.key, required this.list});
  final List<ElementBarDataOperator> list;
  @override
  State<ElementBarOperator> createState() => _ElementBarOperatorState();
}

class _ElementBarOperatorState extends State<ElementBarOperator> {

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
                // context.read<CubitWork>().getOperatorOperations();
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