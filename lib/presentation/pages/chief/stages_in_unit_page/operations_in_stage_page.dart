import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_cubit/stages_in_unit_cubit.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_model.dart';


class OperationsInStagePage extends StatelessWidget {
  const OperationsInStagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stagesInUnitModel =
    ModalRoute
        .of(context)!
        .settings
        .arguments as StagesInUnitModel;
    return BlocProvider(
        create: (context) => StagesInUnitCubit(),
        child: OperationsInStagePageView(
          stagesInUnitModel: stagesInUnitModel,
        ));
  }
}

class OperationsInStagePageView extends StatefulWidget {
  const OperationsInStagePageView({required this.stagesInUnitModel, super.key});

  final StagesInUnitModel stagesInUnitModel;

  @override
  State<OperationsInStagePageView> createState() =>
      _OperationsInStagePageViewState();
}

class _OperationsInStagePageViewState extends State<OperationsInStagePageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocBuilder<StagesInUnitCubit, StagesInUnitState>(
          builder: (context, state) {
            return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [

                    const SizedBox(
                      height: 10,
                    ),
                    Table(
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
                                padding:
                                const EdgeInsets.symmetric(vertical: 8),
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
                            widget.stagesInUnitModel.operationsList.length,
                                (index) =>
                                TableRow(children: [
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .number} ${widget.stagesInUnitModel
                                            .operationsList[index].name}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        widget.stagesInUnitModel
                                            .operationsList[index].code,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index].areaNumber}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .onDistribution}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .distributed}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .onMachinesQuantity}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .onCheckQuantity}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .modificationQuantity}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .readyQuantity}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          '${widget.stagesInUnitModel
                                              .operationsList[index]
                                              .readyPercent}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRowInkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        '${widget.stagesInUnitModel
                                            .operationsList[index]
                                            .defectQuantity}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ]))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Операций на распределении: ${widget
                                      .stagesInUnitModel
                                      .onDistributionOperationsQuantity}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  'Операций в очередях: ${widget.stagesInUnitModel
                                      .distributedOperationsQuantity}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  'Операций на станках: ${widget.stagesInUnitModel
                                      .onMachinesOperationsQuantity}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  'Операций на проверке у мастеров: ${widget
                                      .stagesInUnitModel
                                      .onCheckOperationQuantity}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  'Операций на доработку: ${widget
                                      .stagesInUnitModel
                                      .modificationOperationsQuantity}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green[200],
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Text(
                                    'Годных операций: ${widget.stagesInUnitModel
                                        .readyOperationsQuantity}'),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green[200],
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Text(
                                    'Годных деталей: ${widget.stagesInUnitModel
                                        .readyDetailsQuantity}'),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.red[200],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                    'Забракованых деталей: ${widget
                                        .stagesInUnitModel
                                        .defectOperationsQuantity}'),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }
}
