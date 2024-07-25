import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/distribution_page/distribution_cubit/dispatcher_distribution_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/distribution_page/widgets/dispatcher_distribution_item.dart';

class DispatcherDistributionPage extends StatelessWidget {
  const DispatcherDistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DispatcherDistributionCubit(),
      child: DispatcherDistributionPageView(),
    );
  }
}

class DispatcherDistributionPageView extends StatefulWidget {
  const DispatcherDistributionPageView({super.key});

  @override
  State<DispatcherDistributionPageView> createState() =>
      _DispatcherDistributionPageViewState();
}

class _DispatcherDistributionPageViewState
    extends State<DispatcherDistributionPageView> {
  @override
  void initState() {
    context.read<DispatcherDistributionCubit>().fetchUnits();
    context.read<DispatcherDistributionCubit>().fetchStages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DispatcherDistributionCubit,
        DispatcherDistributionState>(builder: (context, state) {
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                    child: state.status == DispatcherDistributionStatus.success
                        ? ListView.separated(
                            addAutomaticKeepAlives: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Card(
                                  child: ExpansionTile(
                                    maintainState: true,
                                    tilePadding: EdgeInsets.all(0),
                                    title: DispatcherDistributionTitleItem(
                                        state.distributionStagesList[index]),
                                    childrenPadding:
                                        EdgeInsets.fromLTRB(20, 0, 20, 10),
                                    expandedAlignment: Alignment.topLeft,
                                    children: [
                                      DispatcherDistributionBodyItem(
                                        stage:
                                            state.distributionStagesList[index],
                                      )
                                    ],
                                  ),
                                ),
                            separatorBuilder: (ctx, i) => SizedBox(
                                  height: 5,
                                ),
                            itemCount: state.distributionStagesList.length)
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () async {
                await context
                    .read<DispatcherDistributionCubit>()
                    .distributeStages();
                setState(() {
                  context.read<DispatcherDistributionCubit>().fetchStages();
                });
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
