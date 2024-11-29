import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/order.dart';

class OrderInfoPage extends StatelessWidget {
  const OrderInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Order;
    return OrderInfoPageView(
      order: order,
    );
  }
}

class OrderInfoPageView extends StatelessWidget {
  const OrderInfoPageView({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('заказ № ${order.number}'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        'Дата поступления:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${order.dateReceipt}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        'Требуемая дата выполнения:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${order.requiredCompletionDate}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        'Расчетная дата выполнения:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${order.calculatedCompletionDate}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text('Расчетный остаток /\nсрыв срока, выполнения:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      Text('',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        'Фактическая дата выполнения:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${order.actualCompletionDate}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ))),
    );
  }
}
