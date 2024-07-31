import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_cubit/stages_in_unit_cubit.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_model.dart';

class StagesInUnitTitleItem extends StatelessWidget {
  const StagesInUnitTitleItem(
    this.stagesInUnitModel, {
    required this.setState,
    super.key,
  });

  final StageInUnitModel stagesInUnitModel;
  final VoidCallback setState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StagesInUnitCubit(),
      child: StagesInUnitTitleItemView(
        stagesInUnitModel: stagesInUnitModel,
        setState: setState,
      ),
    );
  }
}

class StagesInUnitTitleItemView extends StatefulWidget {
  const StagesInUnitTitleItemView({
    required this.stagesInUnitModel,
    required this.setState,
    super.key,
  });

  final StageInUnitModel stagesInUnitModel;
  final VoidCallback setState;

  @override
  State<StagesInUnitTitleItemView> createState() =>
      _StagesInUnitTitleItemViewState();
}

class _StagesInUnitTitleItemViewState extends State<StagesInUnitTitleItemView> {
  bool isChecked = false;

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
                          Text('этап ${widget.stagesInUnitModel.stageNumber}'),
                          Text(
                              'деталь ${widget.stagesInUnitModel.batchNumber} ${widget.stagesInUnitModel.batchName}')
                        ],
                      ),
                      contentPadding: EdgeInsets.all(5),
                      children: [
                        SimpleDialogOption(
                          padding:
                              EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                          onPressed: () {
                            Navigator.pop(context, false);
                            Navigator.pushNamed(
                                context, '/detailsInUnitQuantityPage',
                                arguments: widget.stagesInUnitModel);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                child: Text('N'),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: Colors.black)),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('количество',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        SimpleDialogOption(
                          padding:
                              EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                          onPressed: () {
                            Navigator.pop(context, false);
                            setState(() {
                              Navigator.pushNamed(
                                  context, '/operationInStagePage',
                                  arguments: widget.stagesInUnitModel);
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                child: Text('O'),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: Colors.black)),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('операции', style: TextStyle(fontSize: 18)),
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
                                              'этап ${widget.stagesInUnitModel.stageNumber}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'деталь ${widget.stagesInUnitModel.batchNumber} ${widget.stagesInUnitModel.batchName}',
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
                                                    '${widget.stagesInUnitModel.readyDetailsQuantity} / ${widget.stagesInUnitModel.availableDetailsQuantity}',
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
                                                    context
                                                        .read<
                                                            StagesInUnitCubit>()
                                                        .uploadStages(
                                                            stagesList: widget
                                                                .stagesInUnitModel
                                                                .stagesList);
                                                    widget.setState();
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
                                                          'Номер чертежа: ${widget.stagesInUnitModel.batchNumber} ${widget.stagesInUnitModel.batchName}'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          '№ этапа: ${widget.stagesInUnitModel.stageNumber}'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          'Номер технологии: ${widget.stagesInUnitModel.technologyNumber}'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          'Код детали: ${widget.stagesInUnitModel.code}')
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
            color: readyPercentToColor(
                widget.stagesInUnitModel.readyDetailsPercent),
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
                            '${widget.stagesInUnitModel.stageNumber}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stagesInUnitModel.batchNumber}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stagesInUnitModel.batchName}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stagesInUnitModel.readyDetailsPercent}%',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${widget.stagesInUnitModel.stageStatusName}',
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
