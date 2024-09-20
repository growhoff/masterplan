import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_cubit/stages_in_unit_cubit.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_model.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batch_model.dart';
import 'package:master_plan/presentation/pages/dispatcher/queue_stages_page/queue_stages_cubit/queue_stages_cubit.dart';

import '../../orders_page/batches_page/stages_in_batch_page.dart';

class QueueStageItem extends StatelessWidget {
  const QueueStageItem(
    this.stageModel, {
    required this.setState,
    super.key,
  });

  final StageModel stageModel;
  final VoidCallback setState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StagesInUnitCubit(),
      child: QueueStageItemView(
        stageModel: stageModel,
        setState: setState,
      ),
    );
  }
}

class QueueStageItemView extends StatefulWidget {
  const QueueStageItemView({
    required this.stageModel,
    required this.setState,
    super.key,
  });

  final StageModel stageModel;
  final VoidCallback setState;

  @override
  State<QueueStageItemView> createState() => _QueueStageItemViewState();
}

class _QueueStageItemViewState extends State<QueueStageItemView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StagesInUnitCubit, StagesInUnitState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('этап ${widget.stageModel.stageNumber}'),
                          Text(
                              'деталь ${widget.stageModel.batch.number} ${widget.stageModel.batch.name}')
                        ],
                      ),
                      contentPadding: EdgeInsets.all(5),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: ctx,
                                builder: (ctx) => SimpleDialog(
                                        title: Column(
                                          children: [
                                            Text('инфо'),
                                            Divider(
                                              height: 2,
                                            ),
                                            Card(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Номер чертежа: ${widget.stageModel.batch.numberRS} ${widget.stageModel.batch.name}'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          '№ этапа: ${widget.stageModel.stageNumber}'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          'Номер технологии: ${widget.stageModel.batch.technology}'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          'Код детали: ${widget.stageModel.batch.code}')
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.all(5),
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        ]));
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline_rounded),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'инфо',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        SimpleDialogOption(
                          padding:
                              EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StagesInBatchPage(
                                        batch: widget.stageModel.batch,
                                        selectedStageId:
                                            widget.stageModel.stageId,
                                      ))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.ac_unit_rounded),
                              SizedBox(
                                width: 8,
                              ),
                              Text('подробная информация',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                        (widget.stageModel.status == 'Выполняется' ||
                                widget.stageModel.status == 'Готов')
                            ? Container()
                            : Divider(
                                height: 1,
                              ),
                        (widget.stageModel.status == 'Выполняется' ||
                                widget.stageModel.status == 'Готов')
                            ? Container()
                            : SimpleDialogOption(
                                onPressed: () async {
                                  await context
                                      .read<QueueStagesCubit>()
                                      .redistribute(widget.stageModel);

                                  widget.setState();
                                },
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.undo_rounded),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'перераспределить',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              )
                      ],
                    ));
          },
          child: Card(
            color: readyPercentToColor(widget.stageModel.readyPercent),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stageModel.batch.order?.number ?? '_'}.${widget.stageModel.batch.number}.${widget.stageModel.stageNumber}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stageModel.batch.numberRS}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stageModel.batch.name}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stageModel.readyToUploadQuantity} / ${widget.stageModel.availableQuantity}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stageModel.readyPercent}%',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stageModel.status}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Color? readyPercentToColor(int readyPercent) {
  if (readyPercent >= 1 && readyPercent < 25) {
    return Colors.green[100];
  }
  if (readyPercent >= 25 && readyPercent < 50) {
    return Colors.green[200];
  }
  if (readyPercent >= 50 && readyPercent < 75) {
    return Colors.green[300];
  }
  if (readyPercent >= 75 && readyPercent < 100) {
    return Colors.green[400];
  }
  if (readyPercent == 100) {
    return Colors.green[500];
  }
  return Colors.white54;
}
