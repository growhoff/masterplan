import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'batches_cubit/batches_cubit.dart';


class BatchesPage extends StatelessWidget {
  const BatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)?.settings.arguments as int;
    return BlocProvider(
        create: (context) => BatchesCubit(orderId),
        child: const BatchesPageView());
  }
}

class BatchesPageView extends StatefulWidget {
  const BatchesPageView({super.key});

  @override
  State<BatchesPageView> createState() => _BatchesPageViewState();
}

class _BatchesPageViewState extends State<BatchesPageView> {
  @override
  void initState() {
    context.read<BatchesCubit>().fetchBatchesInOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Партии')),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addBatchPage',
                          arguments: context.read<BatchesCubit>().orderId)
                      .then((_) =>
                          context.read<BatchesCubit>().fetchBatchesInOrder());
                },
                icon: Icon(
                  Icons.add,
                  size: 28,
                )),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    //context.read<BatchesCubit>().addDetail();
                  },
                  icon: Icon(Icons.format_indent_increase_rounded)),
            )
          ],
        ),
        body: BlocBuilder<BatchesCubit, BatchesState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            softWrap: true,
                                            '${state.batchesList[index].number} ${state.batchesList[index].name}'),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'кол-во ${state.batchesList[index].count}'),
                                      ],
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.edit_rounded)),
                                          IconButton(
                                              onPressed: () {
                                                context
                                                    .read<BatchesCubit>()
                                                    .deleteBatch(state
                                                        .batchesList[index].id);
                                                context
                                                    .read<BatchesCubit>()
                                                    .fetchBatchesInOrder();
                                              },
                                              icon: Icon(Icons.delete_rounded)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        separatorBuilder: (ctx, i) => SizedBox(
                              height: 10,
                            ),
                        itemCount: state.batchesList.length),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
