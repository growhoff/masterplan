import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/order.dart';
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
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              '№ заказа',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              'заказчик',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          flex: 4,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              'приоритет',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              'статус',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          flex: 3,
                        )
                      ],
                    ),
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
                                showDialog(
                                    context: context,
                                    builder: (ctx) => SimpleDialog(
                                          title: Text(
                                              'заказ ${state.ordersList[index].number}'),
                                          contentPadding: EdgeInsets.all(5),
                                          children: [
                                            SimpleDialogOption(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                                Navigator.pushNamed(context,
                                                        '/dispatcherOrderInfoPage',
                                                        arguments: state
                                                            .ordersList[index])
                                                    .then(
                                                        (_) => setState(() {}));
                                              },
                                              child: const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.info_rounded),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'инфо',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            SimpleDialogOption(
                                              onPressed: () {
                                                Navigator.pop(context, false);

                                                Navigator.pushNamed(
                                                    context, '/batchesPage',
                                                    arguments: state
                                                        .ordersList[index]);
                                              },
                                              child: const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.account_tree),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text('состав заказа',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            SimpleDialogOption(
                                              onPressed: () {
                                                Navigator.pop(context, false);

                                                Navigator.pushNamed(
                                                    context, 'editOrderPage',
                                                    arguments: state
                                                        .ordersList[index]);
                                              },
                                              child: const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.edit_rounded),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text('редактировать',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            SimpleDialogOption(
                                              onPressed: () {
                                                setState(() {
                                                  context
                                                      .read<OrdersCubit>()
                                                      .deleteOrder(state
                                                          .ordersList[index]
                                                          .id);
                                                });
                                                Navigator.pop(context, false);
                                              },
                                              child: const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.delete_rounded),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text('удалить',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ));
                              },
                              child: Card(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              '${state.ordersList[index].number}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          flex: 3,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              state.ordersList[index].customer ?? '_',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          flex: 4,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: PriorityCircle(
                                              state.ordersList[index].priority,
                                              size: 22,
                                            ),
                                          ),
                                          flex: 3,
                                        ),
                                        Text(
                                          '${state.ordersList[index].status?.name}',
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    )),
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
