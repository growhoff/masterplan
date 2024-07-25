import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../domain/model/order.dart';
import 'batches_cubit/batches_cubit.dart';

class BatchesPage extends StatelessWidget {
  const BatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Order?;
    return BlocProvider(
        create: (context) => BatchesCubit(order),
        child: BatchesPageView(order: order));
  }
}

class BatchesPageView extends StatefulWidget {
  const BatchesPageView({required this.order,super.key});

  final Order? order;

  @override
  State<BatchesPageView> createState() => _BatchesPageViewState();
}

class _BatchesPageViewState extends State<BatchesPageView> {
  @override
  void initState() {
    context.read<BatchesCubit>().fetchBatchesInOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Партии')),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addBatchPage',
                          arguments: context.read<BatchesCubit>().order)
                      .then((_) =>
                          context.read<BatchesCubit>().fetchBatchesInOrder());
                },
                icon: Icon(
                  Icons.add,
                  size: 28,
                )),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    {
                      context.read<BatchesCubit>().formOrder();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Center(
                                    child: Text('заказ успешно сформирован')),
                                actions: [
                                  Center(
                                    child: MaterialButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Ок',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  )
                                ],
                                elevation: 20,
                              ));
                    }
                    // {
                    //   showDialog(
                    //       context: context,
                    //       builder: (context) => AlertDialog(
                    //             title: Center(
                    //                 child: Text('заказ уже сформирован')),
                    //             actions: [
                    //               Center(
                    //                 child: MaterialButton(
                    //                   onPressed: () => Navigator.pop(context),
                    //                   child: Text(
                    //                     'Ок',
                    //                     style: TextStyle(fontSize: 24),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //             elevation: 20,
                    //           ));
                    // }
                    ;
                  },
                  icon: Icon(Icons.format_indent_increase_rounded)),
            )
          ],
        ),
        body: BlocBuilder<BatchesCubit, BatchesState>(
          builder: (context, state) {
            return Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(3),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                      6: FlexColumnWidth(1),
                      7: FlexColumnWidth(1),
                      8: FlexColumnWidth(1),
                      9: FlexColumnWidth(1),
                      10: FlexColumnWidth(1),
                      11: FlexColumnWidth(1),
                      12: FlexColumnWidth(1),
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
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      '№ заказа',
                                      softWrap: true,
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
                                        '№ чертежа',
                                        textAlign: TextAlign.center,
                                      ),
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
                                    child: Text(
                                      'наименование',
                                    ),
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      'всего требуется в партии',
                                      softWrap: true,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const FittedBox(
                                    fit: BoxFit.fill,
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        'дефицит',
                                        //textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const FittedBox(
                                    fit: BoxFit.fill,
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        'этап в замен дефицита',
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
                                        'в работе',
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
                                        'выполнено',
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
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: const Text(
                                      'отбраковано',
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                            Container(
                              height: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  'статус',
                                  //textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  '% выполнения партии',
                                  //textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]),
                      ...List.generate(
                          state.batchesList.length,
                          (index) => TableRow(children: [
                                TableRowInkWell(
                                  onTap: () => Navigator.pushNamed(context,
                                      '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].batch.order?.number}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].batch.number}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].batch.technology}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].batch.name}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].batch.count}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '0',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '_',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].inWorkQuantity}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].readyQuantity}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(
                                  onTap: () => Navigator.pushNamed(context,
                                      '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].defectQuantity}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${state.batchesList[index].batch.batchStatusName}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableRowInkWell(onTap: () => Navigator.pushNamed(context,
                                    '/dispatcherStagesInBatchesPage', arguments: state.batchesList[index]),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ]))
                    ],
                  ),
                ]));
          },
        ));
  }
}
