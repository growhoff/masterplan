import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/model/order.dart';
import '../../orders_page/widgets/priority_circle.dart';

class ReadyOrdersListElement extends StatelessWidget {
  const ReadyOrdersListElement({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/batchesPage', arguments: order);
      },
      child: Card(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      '${order.number}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      order.customer ?? '_',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    child: PriorityCircle(
                      order.priority,
                      size: 22,
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${order.actualCompletionDate}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${order.status?.name}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => SimpleDialog(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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

                                        Navigator.pushNamed(
                                            context, 'editOrderPage',
                                            arguments: order);
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
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
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
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                      },
                      icon: Icon(Icons.more_vert_rounded)),
                )
              ],
            )),
      ),
    );
  }
}
