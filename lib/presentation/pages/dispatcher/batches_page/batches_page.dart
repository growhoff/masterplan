import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/batches_page/batches_cubit/batches_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_cubit/orders_cubit.dart';

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
    context.read<BatchesCubit>().fetchBatches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Партии'),
        ),
        body: BlocBuilder<BatchesCubit, BatchesState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10)),
                      child: const Text('Добавить деталь',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('номер: ${state.batchesList[index].number}'),
                                          Text('название: ${state.batchesList[index].name}'),
                                          Text('${state.batchesList[index].technology}')
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        separatorBuilder: (ctx, i) => SizedBox(
                              height: 5,
                            ),
                        itemCount: 2),
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
