import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';

class ElementBarOperator extends StatelessWidget {
  const ElementBarOperator({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitWork,StateWork>(builder: (context, state) => Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => context.read<CubitWork>().setActivePage(index),
                child: SizedBox(width: 200, child: Card(color: state.activePage == index ? Colors.blueGrey : const Color.fromARGB(0, 0, 0, 0), child: Center(child: Text(state.list[index].header)))),
              ), 
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemCount: state.list.length),
          ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 16),
            state.list[state.activePage].content
        ],
      ),
    );
  }
}