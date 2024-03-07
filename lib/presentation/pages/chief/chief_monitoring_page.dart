import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_widgets/chief_monitoring_component.dart';

import 'chief_model/element_bar_model.dart';
import 'chief_widgets/element_bar_widget.dart';

class ChiefMonitoringPage extends StatelessWidget {
  const ChiefMonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElementBar(list: listElementBar),
              ],
            )),
      ),
    );
  }
}

class ChiefMonitoringPageView extends StatefulWidget {
  const ChiefMonitoringPageView({super.key, this.title});

  final String? title;

  @override
  State<ChiefMonitoringPageView> createState() =>
      _ChiefMonitoringPageViewState();
}

class _ChiefMonitoringPageViewState extends State<ChiefMonitoringPageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('участок: ${widget.title} '),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Дата: 05.03.2024'),
            SizedBox(width: 10),
            Text('Смена: 2')
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('Оборудование'),
                  SizedBox(height: 10),
                  Text('Станок 1'),
                  SizedBox(height: 10),
                  Text('Станок 2')
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                  children: [
                    Text('Мониторинг', textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    ChiefMonitoringComponent(),
                    SizedBox(height: 10),
                    ChiefMonitoringComponent()
                  ],
                ),
            )
          ],
        ),
      ],
    );
  }
}

List<ElementBarModel> listElementBar = [
  ElementBarModel(
      header: 'Участок 1',
      content:
          const ChiefMonitoringPageView(title: 'название первого участка')),
  ElementBarModel(
      header: 'Участок 2',
      content:
          const ChiefMonitoringPageView(title: 'название второго участка')),
  ElementBarModel(
      header: 'Участок 3',
      content:
          const ChiefMonitoringPageView(title: 'название третьего участка')),
];
