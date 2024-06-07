import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrdersPageView();
  }
}

class OrdersPageView extends StatefulWidget {
  const OrdersPageView({super.key});

  @override
  State<OrdersPageView> createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                    itemBuilder: (context, index) => ExpansionTile(
                          maintainState: true,
                          tilePadding: EdgeInsets.all(0),
                          title: Text('title'),
                          childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                          expandedAlignment: Alignment.topLeft,
                          children: [Text('body')],
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
        ),
      ],
    );
  }
}
