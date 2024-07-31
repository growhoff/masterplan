import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batches_cubit/batches_cubit.dart';

import 'batch_model.dart';

class DispatcherOperationsInStagePage extends StatelessWidget {
  const DispatcherOperationsInStagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stage =
        ModalRoute.of(context)?.settings.arguments as StageInBatchModel;
    return BlocProvider(
      create: (context) => BatchesCubit(),
      child: DispatcherOperationsInStagePageView(
        stage: stage,
      ),
    );
  }
}

class DispatcherOperationsInStagePageView extends StatefulWidget {
  const DispatcherOperationsInStagePageView({required this.stage, super.key});

  final StageInBatchModel stage;

  @override
  State<DispatcherOperationsInStagePageView> createState() =>
      _DispatcherOperationsInStagePageViewState();
}

class _DispatcherOperationsInStagePageViewState
    extends State<DispatcherOperationsInStagePageView> {
  @override
  void initState() {
    context.read<BatchesCubit>().fetchOperationsInStage(widget.stage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('операции'),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<BatchesCubit, BatchesState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                    6: FlexColumnWidth(1),
                    7: FlexColumnWidth(1),
                    8: FlexColumnWidth(1),
                    9: FlexColumnWidth(1),
                    10: FlexColumnWidth(1),
                    11: FlexColumnWidth(1),
                  },
                  defaultColumnWidth: const FlexColumnWidth(),
                  border: TableBorder.all(color: Colors.black),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    '№ операции',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                          TableCell(
                            child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const FittedBox(
                                  fit: BoxFit.fill,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      '№ участка',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                          TableCell(
                            child: Container(
                                color: Colors.blue[200],
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const FittedBox(
                                  fit: BoxFit.fill,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      'на распред.',
                                      //textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                          TableCell(
                            child: Container(
                                height: 100,
                                color: Colors.blue[200],
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    'в очереди',
                                    //textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                          TableCell(
                            child: Container(
                                height: 100,
                                color: Colors.blue[200],
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const FittedBox(
                                  fit: BoxFit.fill,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      'на станках',
                                      //textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                          TableCell(
                            child: Container(
                                height: 100,
                                color: Colors.blue[200],
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const FittedBox(
                                  fit: BoxFit.fill,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      'на проверке',
                                      //textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                          TableCell(
                            child: Container(
                                height: 100,
                                color: Colors.yellow[200],
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                          TableCell(
                            child: Container(
                                height: 100,
                                color: Colors.green[300],
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: const RotatedBox(
                                  quarterTurns: 3,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      softWrap: true,
                                      'годные\nоперации',
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                    ),
                                  ),
                                )),
                          ),
                          TableCell(
                            child: Container(
                                height: 100,
                                color: Colors.green[300],
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: const Text(
                                    '% годных',
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                          Container(
                            height: 100,
                            color: Colors.red[300],
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                'брак',
                                //textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ]),
                    ...List.generate(
                        state.operationsInStageList.length,
                        (index) => TableRow(children: [
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].operation.number} ${state.operationsInStageList[index].operation.name}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].operation.code}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].areaNumber}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].onDistribution}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].distributed}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].onMachinesQuantity}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].onCheckQuantity}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].modificationQuantity}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].readyQuantity}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.operationsInStageList[index].readyPercent}%',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              TableRowInkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${state.operationsInStageList[index].defectQuantity}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ]))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
