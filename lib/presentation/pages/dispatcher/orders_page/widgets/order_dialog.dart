import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_cubit/orders_cubit.dart';

import '../../../../../domain/model/order.dart';

class OrderDialogIconButton extends StatelessWidget {
  const OrderDialogIconButton({required this.cubit, required this.order, super.key});

  final OrdersCubit cubit;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    title: Text('заказ ${order.number}'),
                    contentPadding: EdgeInsets.all(5),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, false);
                          Navigator.pushNamed(
                              context, '/dispatcherOrderInfoPage',
                              arguments: order);
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.info_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'инфо',
                              style: TextStyle(fontSize: 18),
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

                          Navigator.pushNamed(context, 'editOrderPage',
                              arguments: order);
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('редактировать',
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                           cubit.deleteOrder(order.id);
                          Navigator.pop(context, false);

                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text('удалить', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      )
                    ],
                  ));
        },
        icon: Icon(Icons.more_vert_rounded));
  }
}
