import 'package:flutter/cupertino.dart';
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
   // context.read<ChiefDistributionCubit>().fetchChiefOperations();
    context.read<ChiefDistributionCubit>().fetchAreas();

    super.initState();
    context.read<ChiefDistributionCubit>().listControllerAddListener();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChiefDistributionCubit, ChiefDistributionState>(
        builder: (context, state) {
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      await context
                          .read<ChiefDistributionCubit>()
                          .loadStageFromExcel();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('этап загружается. пожалуйста, подождите')));
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10)),
                    child: const Text('Загрузить этапы (excel)',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                state.status == DistributionPageStatus.success
                    ?
                    Expanded(
                        child: ListView.separated(
                          physics: AlwaysScrollableScrollPhysics(),
                            controller: context
                                .read<ChiefDistributionCubit>()
                                .listController,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => index <
                                    state.chiefOperationsList.length
                                ? ExpansionTile(
                              maintainState: true,
                                    tilePadding: EdgeInsets.all(0),
                                    title: ChiefOperationDistributionTitleItem(
                                        state.chiefOperationsList[index]),
                                    childrenPadding:
                                        EdgeInsets.fromLTRB(20, 0, 20, 10),
                                    expandedAlignment: Alignment.topLeft,
                                    children: [
                                      ChiefOperationDistributionBodyItem(
                                        operation:
                                            state.chiefOperationsList[index],
                                      )
                                    ],
                                  )
                                : SizedBox(
                                    height: 50,
                                  ),
                            separatorBuilder: (ctx, i) => SizedBox(
                                  height: 5,
                                ),
                            itemCount: state.chiefOperationsList.length + 1),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                const SizedBox(
                  height: 50,
                ),
              ],
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
              child: const Text('отправить в работу',
                  style: TextStyle(fontSize: 18)),
            ),
          )
        ],
      );
    });
  }
}
