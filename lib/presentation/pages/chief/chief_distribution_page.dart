import 'package:flutter/material.dart';

import 'chief_widgets/chief_distribution_operations_element.dart';

class ChiefDistributionPage extends StatelessWidget {
  const ChiefDistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChiefDistributionPageView();
  }
}

class ChiefDistributionPageView extends StatefulWidget {
  const ChiefDistributionPageView({super.key});

  @override
  State<ChiefDistributionPageView> createState() =>
      _ChiefDistributionPageViewState();
}

class _ChiefDistributionPageViewState extends State<ChiefDistributionPageView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    ChiefDistributionOperationsElement(
                      stageNumber: '123.3221',
                      operationsCount: index,
                      operationsNumber: index,
                      operationsName: '$index токарная',
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: 4),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
            child: const Text('отправить в работу', style: TextStyle(fontSize: 18)),
          )
        ],
      ),
    ));
  }
}
