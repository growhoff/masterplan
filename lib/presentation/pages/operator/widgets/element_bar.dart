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
          SizedBox(
            height: 40,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () =>
                          context.read<CubitWork>().setActivePage(index),
                      child: SizedBox(
                          width: 200,
                          child: Card(
                              color: state.activePage == index ? Colors.blueGrey : const Color.fromARGB(0, 0, 0, 0),
                              child: Center(child: Text(state.pageData[index].machine.name)))),
                    ),
                separatorBuilder: (context, index) => const SizedBox(width: 5),
                itemCount: state.pageData.length),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 16),
          ContentDetail(state.pageData[state.activePage], state.statusBtn[state.activePage])
        ],
      )
      : const Center(child: CircularProgressIndicator()),
    );
  }
}
