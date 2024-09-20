import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/content_details.dart';

class ElementBarOperator extends StatelessWidget {
  const ElementBarOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitWork, StateWork>(
      builder: (context, state) => state.pageData.isNotEmpty ? Column(
        children: [
          const Divider(),
          SizedBox(
            height: 50,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () => context.read<CubitWork>().setActivePage(index),
                      child: Card(
                          color: state.activePage == index ? const Color.fromARGB(255, 27, 179, 255) : const Color.fromARGB(0, 189, 189, 189),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(state.pageData[index].machine.name)),
                          )),
                    ),
                separatorBuilder: (context, index) => const SizedBox(width: 5),
                itemCount: state.pageData.length),
          ),
          const Divider(),
          Text('${state.listChange[state.activePage]} смена'),
          const Divider(),
          const SizedBox(height: 16),
          ContentDetail(state.pageData[state.activePage], state.statusBtn[state.activePage], state.count, state.activeTransfer)
        ],
      )
      : const Center(child: CircularProgressIndicator()),
    );
  }
}
