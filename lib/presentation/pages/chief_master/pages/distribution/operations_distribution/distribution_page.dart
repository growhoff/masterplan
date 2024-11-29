import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './widgets/details_distribution_item.dart';
import 'chief_distribution_cubit/chief_distribution_cubit.dart';

class ChiefDistributionPageChM extends StatelessWidget {
  const ChiefDistributionPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefDistributionChMCubit(),
      child: const ChiefDistributionPageView(),
    );
  }
}

class ChiefDistributionPageView extends StatefulWidget {
  const ChiefDistributionPageView({super.key});
  @override
  State<ChiefDistributionPageView> createState() => _ChiefDistributionPageViewState();
}

class _ChiefDistributionPageViewState extends State<ChiefDistributionPageView> {
  @override
  void initState() {
    context.read<ChiefDistributionChMCubit>().fetchChiefOperations();
    context.read<ChiefDistributionChMCubit>().fetchAreas();
    super.initState();
    context.read<ChiefDistributionChMCubit>().listControllerAddListener();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChiefDistributionChMCubit, ChiefDistributionChMState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Распределение операций'),),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await context.read<ChiefDistributionChMCubit>().loadStageFromExcel();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('этап загружается. пожалуйста, подождите')));
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                      child: const Text('Загрузить этапы (excel)', style: TextStyle(fontSize: 18)),
                    ),
                  const SizedBox(height: 10),
                  state.status == DistributionPageStatus.success
                      ?
                      Expanded(
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                              controller: context
                                  .read<ChiefDistributionChMCubit>()
                                  .listController,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => index <
                                      state.chiefOperationsList.length
                                  ? ExpansionTile(
                                maintainState: true,
                                      tilePadding: const EdgeInsets.all(0),
                                      title: ChiefOperationDistributionTitleItem(
                                          state.chiefOperationsList[index]),
                                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                      expandedAlignment: Alignment.topLeft,
                                      children: [
                                        ChiefOperationDistributionBodyItem(
                                          operation:
                                              state.chiefOperationsList[index],
                                        )
                                      ],
                                    )
                                  : const SizedBox(height: 50),
                              separatorBuilder: (ctx, i) => const SizedBox(height: 5),
                              itemCount: state.chiefOperationsList.length + 1),
                        )
                      : const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () => context.read<ChiefDistributionChMCubit>().sendOperationsToDistribution(),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
                child: const Text('отправить в работу', style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      );
    });
  }
}
