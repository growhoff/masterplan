import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batch_model.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batches_cubit/batches_cubit.dart';

import '../../../../../domain/model/order.dart';

class StagesInBatchPage extends StatelessWidget {
  const StagesInBatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final batch = ModalRoute.of(context)?.settings.arguments as BatchModel;
    return BlocProvider(
      create: (context) => BatchesCubit(order: batch.batch.order),
      child: StagesInBatchPageView(
        batch: batch,
      ),
    );
  }
}

class StagesInBatchPageView extends StatefulWidget {
  const StagesInBatchPageView({required this.batch, super.key});

  final BatchModel batch;

  @override
  State<StagesInBatchPageView> createState() => _StagesInBatchPageViewState();
}

class _StagesInBatchPageViewState extends State<StagesInBatchPageView> {
  @override
  void initState() {
    context.read<BatchesCubit>().fetchStagesInBatch(widget.batch.batch.id);
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
                                        '${widget.batch.batch.numberRS} ${widget.batch.batch.name}')
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
                                    Text('${widget.batch.batch.technology}')
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
                                    widget.batch.batch.code != ''
                                        ? Text('${widget.batch.batch.code}')
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
                                    Text('${widget.batch.batch.count}')
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
                                    Text('${widget.batch.readyQuantity}')
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
                                    Text('${widget.batch.readyPercent}%')
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
                            9: FlexColumnWidth(1.5),
                            10: FlexColumnWidth(3),
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
                                        color: Colors.blue[200],
                                        alignment: Alignment.center,
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: FittedBox(
                                            child: Text(
                                              'Готовые к\nвыгрузке',
                                              softWrap: true,
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  ),
                                  TableCell(
                                    child: Container(
                                        height: 100,
                                        color: Colors.blue[300],
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              'Всего на\nтекущем этапе',
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const FittedBox(
                                          fit: BoxFit.fill,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              'Ожидается от\nпредыдущих этапов',
                                              textAlign: TextAlign.center,
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
                                              'Выгружено на\nследующий этап/склад',
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
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: const RotatedBox(
                                          quarterTurns: 3,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              softWrap: true,
                                              'Всего доступно в этапе',
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
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
                                              'Всего отбраковано\nв этапе',
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
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${widget.batch.batch.order?.number}.${widget.batch.batch.number}.${state.stagesInBatchList[index].stageNumber}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].stageName}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].inWorkQuantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].readyToUploadQuantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].allOnStageQuantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].waitFromPrevStagesQuantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].uploadedQuantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].readyQuantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].defectQuantity}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].readyPercent}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableRowInkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/dispatcherOperationsInStagePage',
                                              arguments: state
                                                  .stagesInBatchList[index]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            '${state.stagesInBatchList[index].status}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
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
