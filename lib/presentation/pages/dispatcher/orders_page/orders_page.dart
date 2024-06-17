import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_cubit/orders_cubit.dart';

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
    return Stack(
      children: [
        BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.success) {
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
                        child: const Text('Добавить заказ',
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
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/batchesPage', arguments: state.ordersList[index].id);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'номер: ${state.ordersList[index].number}'),
                                            Text(
                                                'приоритет: ${state.ordersList[index].priority}')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  textAlign: TextAlign.center,
                                                  "дата поступления\n${state.ordersList[index].dateReceipt}"),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  textAlign: TextAlign.center,
                                                  "планируемая дата завершения\n${state.ordersList[index].datePlanCompletion}"),
                                            ),
                                          ],
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
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
