import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_cubit/orders_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/widgets/priority_circle.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OrdersCubit(), child: const OrdersPageView());
  }
}

class OrdersPageView extends StatefulWidget {
  const OrdersPageView({super.key});

  @override
  State<OrdersPageView> createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageView> {
  @override
  void initState() {
    context.read<OrdersCubit>().fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.status == OrdersStatus.success) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addOrderPage').then(
                          (_) => context.read<OrdersCubit>().fetchOrders());
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10)),
                    child: const Text('Добавить заказ',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/batchesPage',
                                        arguments: state.ordersList[index])
                                    .then((_) => context
                                        .read<OrdersCubit>()
                                        .fetchOrders());
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              'номер: ${state.ordersList[index].number}'),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              textAlign: TextAlign.center,
                                              "дата поступления\n${state.ordersList[index].dateReceipt}"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              textAlign: TextAlign.center,
                                              "планируемая дата завершения\n${state.ordersList[index].datePlanCompletion}"),
                                          const SizedBox(
                                            height: 10,

                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          PriorityCircle(
                                            state.ordersList[index].priority,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.edit_rounded)),
                                          IconButton(
                                              onPressed: () {
                                                context
                                                    .read<OrdersCubit>()
                                                    .deleteOrder(state
                                                        .ordersList[index].id);
                                                context
                                                    .read<OrdersCubit>()
                                                    .fetchOrders();
                                              },
                                              icon: Icon(Icons.delete_rounded))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      separatorBuilder: (ctx, i) => SizedBox(
                            height: 5,
                          ),
                      itemCount: state.ordersList.length),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
