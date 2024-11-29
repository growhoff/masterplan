import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/ready_orders_page/ready_orders_cubit/ready_orders_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/ready_orders_page/widgets/ready_orders_list_element.dart';

class ReadyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadyOrdersCubit(),
      child: ReadyOrdersPageView(),
    );
  }
}

class ReadyOrdersPageView extends StatefulWidget {
  @override
  State<ReadyOrdersPageView> createState() => _ReadyOrdersPageViewState();
}

class _ReadyOrdersPageViewState extends State<ReadyOrdersPageView> {
  @override
  void initState() {
    context.read<ReadyOrdersCubit>().fetchReadyOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadyOrdersCubit, ReadyOrdersState>(
      builder: (context, state) {
        if (state is ReadyOrdersSuccess) {
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
                              'факт.\nдата',
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
                      itemBuilder: (context, index) => ReadyOrdersListElement(
                            order: state.ordersList[index],
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
