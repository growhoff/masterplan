
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:master_plan/presentation/pages/chief/statistics_page/statictics_cubit/statistics_cubit.dart';
import 'package:master_plan/presentation/pages/chief/statistics_page/statistics_stage_model.dart';

class OperationsStatisticsPage extends StatelessWidget {
  const OperationsStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statisticsStage =
        ModalRoute.of(context)!.settings.arguments as StatisticsStageModel;
    return BlocProvider(
        create: (context) => StatisticsCubit(),
        child: OperationsStatisticsPageView(
          statisticsStage: statisticsStage,
        ));
  }
}

class OperationsStatisticsPageView extends StatefulWidget {
  const OperationsStatisticsPageView(
      {required this.statisticsStage, super.key});

  final StatisticsStageModel statisticsStage;

  @override
  State<OperationsStatisticsPageView> createState() =>
      _OperationsStatisticsPageViewState();
}

class _OperationsStatisticsPageViewState
    extends State<OperationsStatisticsPageView> {

  @override
  void initState() {
    context.read<StatisticsCubit>().fetchReadyPercent(stage: widget.statisticsStage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocBuilder<StatisticsCubit, ChiefStatisticsState>(
          builder: (context, state) {
            return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Номер чертежа: ${widget.statisticsStage.stage.batch!.name}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '№ этапа: ${widget.statisticsStage.stage.number}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  'Кол-во деталей: ${widget.statisticsStage.stage.batch?.count}')
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(3),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                          7: FlexColumnWidth(1),
                        },
                        defaultColumnWidth: const FlexColumnWidth(),
                        border: TableBorder.all(color: Colors.black),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                              decoration: const BoxDecoration(color: Colors.grey),
                              children: [
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      child: const FittedBox(
                                        fit: BoxFit.fill,
                                        child: Text(
                                          'наименование\nоперации',
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          '№',
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          'участок',
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'кол-во выполненных деталей',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        '%',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: const FittedBox(
                                        fit: BoxFit.fill,
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            'в  работе',
                                            //textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: const FittedBox(
                                        fit: BoxFit.fill,
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            'брак',
                                            //textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )),
                                ),
                                TableCell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: const FittedBox(
                                        fit: BoxFit.fill,
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            'доработка',
                                            //textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )),
                                ),

                              ]),
                          ...List.generate(
                              widget.statisticsStage.operationsList.length,
                              (index) => TableRow(children: [
                                    TableRowInkWell(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          widget.statisticsStage.operationsList[index].operation.name,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableRowInkWell(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          widget.statisticsStage.operationsList[index].operation.code,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                TableRowInkWell(
                                  child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      widget.statisticsStage.operationsList[index].area?.number ?? '',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                    TableRowInkWell(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          '${widget.statisticsStage.operationsList[index].statusMap[6]}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableRowInkWell(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          '${widget.statisticsStage.operationsList[index].readyPercent}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableRowInkWell(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          '${widget.statisticsStage.operationsList[index].statusMap[7]}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableRowInkWell(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          '${widget.statisticsStage.operationsList[index].statusMap[5]}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    TableRowInkWell(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          '${widget.statisticsStage.operationsList[index].statusMap[4]}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ]))
                        ],
                      ),
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
