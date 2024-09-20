import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/chief_distirbution_cubit/chief_distribution_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/widgets/chief_distribution_list_item.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/widgets/units_dropdown_button.dart';

import '../../../../domain/model/unit.dart';

class ChiefDistributionPage extends StatelessWidget {
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
    context.read<ChiefDistributionCubit>().initChiefDistributionPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChiefDistributionCubit, ChiefDistributionState>(
      builder: (context, state) {
        if (state is ChiefDistributionSuccess) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  state.unitsList.length > 1
                      ? UnitsDropdownButton(
                          unitsList: state.unitsList,
                          cubit: context.read<ChiefDistributionCubit>(),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                      color: Colors.grey[300],
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 4,
                                child: Column(children: [
                                  Text('№ этапа, наименование',
                                      textAlign: TextAlign.center),
                                  Text('№ чертежа, наименование',
                                      textAlign: TextAlign.center)
                                ])),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  'пришло/\nожидается, шт.',
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text('приоритет',
                                        textAlign: TextAlign.center),
                                  ),
                                ))
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),


                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) =>
                            ChiefDistributionListItem(state.stagesList[index]),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: state.stagesList.length),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
