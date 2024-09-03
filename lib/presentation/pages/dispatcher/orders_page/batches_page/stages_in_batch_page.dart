import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batch_model.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batches_cubit/batches_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/widgets/stages_in_batch_table_cell.dart';

import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/order.dart';

class StagesInBatchPage extends StatelessWidget {
  const StagesInBatchPage(
      {super.key, this.selectedStageId, required this.batch});

  final Batch batch;
  final int? selectedStageId;

  @override
  Widget build(BuildContext context) {
    //final batch = ModalRoute.of(context)?.settings.arguments as Batch;
    return BlocProvider(
      create: (context) => BatchesCubit(),
      child: StagesInBatchPageView(
        batch: batch,
        selectedStageId: selectedStageId,
      ),
    );
  }
}

class StagesInBatchPageView extends StatefulWidget {
  const StagesInBatchPageView(
      {required this.batch, this.selectedStageId, super.key});

  final Batch batch;
  final int? selectedStageId;

  @override
  State<StagesInBatchPageView> createState() => _StagesInBatchPageViewState();
}

class _StagesInBatchPageViewState extends State<StagesInBatchPageView> {
  @override
  void initState() {
    context.read<BatchesCubit>().fetchStagesInBatch(widget.batch.id);
    print('selectedStageid: ${widget.selectedStageId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('этапы'),
        ),
        body: BlocBuilder<BatchesCubit, BatchesState>(
            builder: (context, state) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Номер четрежа,\nнаименование',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        '${widget.batch.numberRS} ${widget.batch.name}')
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Номер технологии',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text('${widget.batch.technology}')
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Код детали',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    widget.batch.code != ''
                                        ? Text('${widget.batch.code}')
                                        : Text('_')
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Всего отбраковано / требуется',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text('0')
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Всего требуется в партии',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text('${widget.batch.count}')
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Всего выполнено',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text('readyQuantity')
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '% выполнения партии',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text('readyPercent%')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                            6: FlexColumnWidth(1),
                            7: FlexColumnWidth(1),
                            8: FlexColumnWidth(1),
                            9: FlexColumnWidth(1),
                            10: FlexColumnWidth(1.5),
                            11: FlexColumnWidth(3),
                          },
                          defaultColumnWidth: const FlexColumnWidth(),
                          border: TableBorder.all(color: Colors.black),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                                decoration:
                                    const BoxDecoration(color: Colors.grey),
                                children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            '№ Этапа',
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const FittedBox(
                                          fit: BoxFit.fill,
                                          child: Text(
                                            'Наименование\nэтапа',
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              '№ цеха',
                                            ),
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        color: Colors.blue[200],
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              'В работе в цехе',
                                            ),
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        color: Colors.yellow[200],
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              'Готово на отправку в цехе',
                                            ),
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        color: Colors.red[300],
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: const Text(
                                              'Отбраковано',
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        color: Colors.green[300],
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: const Text(
                                              'Отправлено',
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        color: Colors.orange[200],
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: const Text(
                                              'Ожидается',
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  ),
                                  Container(
                                    height: 100,
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          '% выполнения\nэтапа',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: const Text(
                                            'Состояние\nэтапа',
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ),
                                ]),
                            ...List.generate(
                                state.stagesInBatchList.length,
                                (index) => TableRow(children: [
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].batch.order?.number ?? '_'}.${widget.batch.number}.${state.stagesInBatchList[index].stageNumber}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isFirstInRow: true,
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].stageName}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].unitNumber}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].inWorkQuantity}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].readyToUploadQuantity}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].defectQuantity}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].uploadedQuantity}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].waitFromPrevStagesQuantity}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].readyPercent}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                      ),
                                      StagesInBatchTableCell(
                                        '${state.stagesInBatchList[index].status}',
                                        stageModel:
                                            state.stagesInBatchList[index],
                                        isSelected: state
                                                    .stagesInBatchList[index]
                                                    .stageId ==
                                                widget.selectedStageId
                                            ? true
                                            : false,
                                        isLastInRow: true,
                                      ),
                                    ]))
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
