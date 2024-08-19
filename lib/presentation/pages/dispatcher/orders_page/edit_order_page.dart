import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/order.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_cubit/orders_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/widgets/priority_circle.dart';

class EditOrderPage extends StatelessWidget {
  const EditOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Order;

    return BlocProvider(
      create: (context) => OrdersCubit(),
      child: EditOrderPageView(
        order: order,
      ),
    );
  }
}

class EditOrderPageView extends StatefulWidget {
  const EditOrderPageView({required this.order, super.key});

  final Order order;

  @override
  State<EditOrderPageView> createState() => _EditOrderPageViewState();
}

class _EditOrderPageViewState extends State<EditOrderPageView> {
  @override
  void initState() {
    context.read<OrdersCubit>().initEditOrderPage(widget.order);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('редактирование заказа'),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Flexible(
                            child: Text(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              'номер',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller:
                                  context.read<OrdersCubit>().numberController,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Flexible(
                            child: Text(
                          'дата получения',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(fontSize: 20),
                        )),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2024),
                                lastDate: DateTime.now());
                            setState(() {
                              if (pickedDate != null) {
                                context.read<OrdersCubit>().receiptDate =
                                    pickedDate;
                              }
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(
                                          4, 4), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month_rounded),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${context.read<OrdersCubit>().receiptDate.day}.${context.read<OrdersCubit>().receiptDate.month}.${context.read<OrdersCubit>().receiptDate.year}',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Text(
                          'планируемая дата завершения',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(fontSize: 20),
                        )),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2100));
                            setState(() {
                              if (pickedDate != null) {
                                context
                                    .read<OrdersCubit>()
                                    .requiredCompletionDate = pickedDate;
                              }
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(
                                          4, 4), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month_rounded),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      softWrap: true,
                                      '${context.read<OrdersCubit>().requiredCompletionDate.day}.${context.read<OrdersCubit>().requiredCompletionDate.month}.${context.read<OrdersCubit>().requiredCompletionDate.year}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Flexible(
                            child: Text(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              'заказчик',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: context
                                  .read<OrdersCubit>()
                                  .customerController,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Flexible(
                            child: Text(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              'приоритет',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Center(
                            child: DropdownButton(
                                isDense: true,
                                value: context
                                    .read<OrdersCubit>()
                                    .selectedPriority,
                                items: context
                                    .read<OrdersCubit>()
                                    .prioritiesList
                                    .map((int priority) => DropdownMenuItem(
                                        value: priority,
                                        child: PriorityCircle(
                                          priority,
                                          size: 20,
                                        )))
                                    .toList(),
                                onChanged: (priority) => setState(() {
                                      context
                                          .read<OrdersCubit>()
                                          .selectedPriority = priority ?? 1;
                                    })),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20))),
                        onPressed: () async {
                          await context.read<OrdersCubit>().editOrder(widget.order);
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'редактировать',
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
