import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_cubit/stages_in_unit_cubit.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_model.dart';

import '../../../dispatcher/orders_page/batches_page/batch_model.dart';
import '../../../dispatcher/orders_page/batches_page/stages_in_batch_page.dart';

class StagesInUnitTitleItem extends StatelessWidget {
  const StagesInUnitTitleItem(
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
      child: StagesInUnitTitleItemView(
        stageModel: stageModel,
        setState: setState,
      ),
    );
  }
}

class StagesInUnitTitleItemView extends StatefulWidget {
  const StagesInUnitTitleItemView({
    required this.stageModel,
    required this.setState,
    super.key,
  });

  final StageModel stageModel;
  final VoidCallback setState;

  @override
  State<StagesInUnitTitleItemView> createState() =>
      _StagesInUnitTitleItemViewState();
}

class _StagesInUnitTitleItemViewState extends State<StagesInUnitTitleItemView> {
  bool _isValidate = true;

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StagesInBatchPage(
                                          batch: widget.stageModel.batch,
                                          selectedStageId:
                                              widget.stageModel.stageId,
                                        )));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.ac_unit),
                              const SizedBox(
                                width: 10,
                              ),
                              Text('подробная информация')
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context, false);
                            setState(() {});
                            showDialog(
                                context: ctx,
                                builder: (ctx) => SimpleDialog(
                                        title: Column(
                                          children: [
                                            Text('выгрузка диспетчеру'),
                                            Divider(
                                              height: 2,
                                            ),
                                            Text(
                                              'этап ${widget.stageModel.stageNumber}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'деталь ${widget.stageModel.batch.number} ${widget.stageModel.batch.name}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('готово к выгрузке: ',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text(
                                                    '${widget.stageModel.readyToUploadQuantity} / ${widget.stageModel.availableQuantity}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
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
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('кол-во: '),
                                                    SizedBox(
                                                        width: 100,
                                                        child: TextField(
                                                          decoration: InputDecoration(
                                                              fillColor: _isValidate
                                                                  ? Colors
                                                                      .white54
                                                                  : Colors.red[
                                                                      100]),
                                                          controller: context
                                                              .read<
                                                                  StagesInUnitCubit>()
                                                              .uploadStagesQuantityController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    int.parse(context
                                                                .read<
                                                                    StagesInUnitCubit>()
                                                                .uploadStagesQuantityController
                                                                .text) <=
                                                            widget.stageModel
                                                                .readyToUploadQuantity
                                                        ? {
                                                            _isValidate = true,
                                                            context
                                                                .read<
                                                                    StagesInUnitCubit>()
                                                                .uploadStages(
                                                                    stageModel: widget
                                                                        .stageModel),
                                                            widget.setState()
                                                          }
                                                        : setState(() {
                                                            _isValidate = false;
                                                          });
                                                  },
                                                  child: Text('выгрузить'))
                                            ],
                                          )
                                        ]));
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.file_upload_outlined),
                              SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: Text(
                                  'выгрузить детали на следующий этап',
                                  style: TextStyle(fontSize: 18),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
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
                                                          'Номер чертежа: ${widget.stageModel.batch.number} ${widget.stageModel.batch.name}'),
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
                        flex: 1,
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
