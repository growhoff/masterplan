import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/operations_distribution_page/widgets/details_distribution_item.dart';

import 'chief_distribution_cubit/chief_distribution_cubit.dart';

class ChiefDistributionPage extends StatelessWidget {
  const ChiefDistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefDistributionCubit(),
      child: ChiefDistributionPageView(),
    );
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
  void initState() {
    context.read<ChiefDistributionCubit>().fetchChiefOperations();
    context.read<ChiefDistributionCubit>().fetchAreas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChiefDistributionCubit, ChiefDistributionState>(
        builder: (context, state) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<ChiefDistributionCubit>()
                            .loadStageFromExcel();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10)),
                      child: const Text('Загрузить этапы (excel)',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ExpansionPanelList(
                    children: [
                      ...List.generate(
                          state.chiefOperationsList.length,
                          (index) => ExpansionPanel(
                              isExpanded: context
                                  .read<ChiefDistributionCubit>()
                                  .isElementOpenList[index],
                              headerBuilder: (context, isOpen) =>
                                  ChiefOperationDistributionTitleItem(
                                      state.chiefOperationsList[index]),
                              body: ChiefOperationDistributionBodyItem(
                                operation: state.chiefOperationsList[index],
                              )))
                    ],
                    expansionCallback: (i, isOpen) => setState(() {
                      context
                          .read<ChiefDistributionCubit>()
                          .isElementOpenList[i] = isOpen;
                    }),
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<ChiefDistributionCubit>()
                    .sendOperationsToDistribution();
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15)),
              child: const Text('отправить в работу',
                  style: TextStyle(fontSize: 18)),
            ),
          )
        ],
      );
    });
  }
}
