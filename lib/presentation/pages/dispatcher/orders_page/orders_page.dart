import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/order.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_cubit/orders_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/widgets/order_dialog.dart';
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
                          flex: 3,
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
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
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
                      itemBuilder: (context, index) => Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/batchesPage',
                                    arguments: state.ordersList[index]);
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
                                              state.ordersList[index]
                                                      .customer ??
                                                  '_',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          flex: 3,
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
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '${state.ordersList[index].status?.name}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: OrderDialogIconButton(
                                              cubit: context.read<
                                                  OrdersCubit>(),
                                              order: state
                                                  .ordersList[
                                              index]),
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
