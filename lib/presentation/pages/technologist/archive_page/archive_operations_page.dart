import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/stage_archive.dart';
import 'archive_cubit/archive_cubit.dart';

class DispatcherArchiveOperationsPage extends StatelessWidget {
  const DispatcherArchiveOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stageArchive =
        ModalRoute.of(context)!.settings.arguments as StageArchive;
    return BlocProvider(
      create: (context) => ArchiveCubit(),
      child: DispatcherArchiveOperationsPageView(
        stageArchive: stageArchive,
      ),
    );
  }
}

class DispatcherArchiveOperationsPageView extends StatefulWidget {
  final StageArchive stageArchive;

  const DispatcherArchiveOperationsPageView(
      {required this.stageArchive, super.key});

  @override
  State<DispatcherArchiveOperationsPageView> createState() =>
      _DispatcherArchiveOperationsPageViewState();
}

class _DispatcherArchiveOperationsPageViewState
    extends State<DispatcherArchiveOperationsPageView> {
  @override
  void initState() {
    context
        .read<ArchiveCubit>()
        .fetchOperations(stageId: widget.stageArchive.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: FittedBox(
        child: Column(
          children: [
            Text(
              '${widget.stageArchive.number} ${widget.stageArchive.name}',
              softWrap: true,
            ),
            Text('(операции)')
          ],
        ),
      )),
      body: BlocBuilder<ArchiveCubit, ArchiveState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(4)
                    },
                    defaultColumnWidth: FlexColumnWidth(),
                    border: TableBorder.all(color: Colors.black),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.grey),
                          children: [
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Код',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '№ операции',
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'наименование',
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ]),
                      ...List.generate(
                          state.operationsList.length,
                          (index) => TableRow(children: [
                                TableRowInkWell(
                                  onTap: () async{
                                    int len = await context.read<ArchiveCubit>().fetchTransfers(
                                        operationId:
                                        state.operationsList[index].id);

                                    print('len : $len');

                                    if (len!=0) {
                                      Navigator.pushNamed(context,
                                          '/dispatcherArchiveTransferPage',
                                          arguments:
                                          context.read<ArchiveCubit>());
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Text('переходов нет')));
                                    }
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${state.operationsList[index].code}',
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                TableRowInkWell(
                                  onTap: () async{
                                    int len = await context.read<ArchiveCubit>().fetchTransfers(
                                        operationId:
                                        state.operationsList[index].id);

                                    print('len : $len');

                                    if (len!=0) {
                                      Navigator.pushNamed(context,
                                          '/dispatcherArchiveTransferPage',
                                          arguments:
                                          context.read<ArchiveCubit>());
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Text('переходов нет')));
                                    }
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${state.operationsList[index].number}',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                TableRowInkWell(
                                  onTap: () async{
                                   int len = await context.read<ArchiveCubit>().fetchTransfers(
                                        operationId:
                                            state.operationsList[index].id);

                                    print('len : $len');

                                    if (len!=0) {
                                      Navigator.pushNamed(context,
                                          '/dispatcherArchiveTransferPage',
                                          arguments:
                                              context.read<ArchiveCubit>());
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text('переходов нет')));
                                    }
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${state.operationsList[index].name}',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ]))
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
