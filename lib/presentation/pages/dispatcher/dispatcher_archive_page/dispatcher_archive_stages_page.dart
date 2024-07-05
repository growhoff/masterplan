import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/archive_cubit/archive_cubit.dart';

import '../../../../domain/model/batch.dart';
import '../../../../domain/model/batch_archive.dart';
import 'archive_cubit/dispatcher_archive_cubit.dart';

class DispatcherArchiveStagesPage extends StatelessWidget {
  const DispatcherArchiveStagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final batchArchive =
        ModalRoute.of(context)!.settings.arguments as BatchArchive;
    return BlocProvider(
      create: (context) => DispatcherArchiveCubit(),
      child: DispatcherArchiveStagesPageView(
        batchArchive: batchArchive,
      ),
    );
  }
}

class DispatcherArchiveStagesPageView extends StatefulWidget {
  final BatchArchive batchArchive;

  const DispatcherArchiveStagesPageView({required this.batchArchive, super.key});

  @override
  State<DispatcherArchiveStagesPageView> createState() => _DispatcherArchiveStagesPageViewState();
}

class _DispatcherArchiveStagesPageViewState extends State<DispatcherArchiveStagesPageView> {
  @override
  void initState() {
    context
        .read<DispatcherArchiveCubit>()
        .fetchStages(batchArchiveId: widget.batchArchive.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.batchArchive.name} (этапы)',
          softWrap: true,
        ),
      ),
      body: BlocBuilder<DispatcherArchiveCubit, DispatcherArchiveState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(3)
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
                                    '№ по РС',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'наименование',
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '№ этапа',
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ]),
                      ...List.generate(
                          state.stagesList.length,
                          (index) => TableRow(children: [
                                TableRowInkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/dispatcherArchiveOperationsPage',
                                        arguments: state.stagesList[index]);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${index + 1}',
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                TableRowInkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/dispatcherArchiveOperationsPage',
                                        arguments: state.stagesList[index]);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${state.stagesList[index].name}',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                TableRowInkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/dispatcherArchiveOperationsPage',
                                        arguments: state.stagesList[index]);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${state.stagesList[index].number}',
                                        textAlign: TextAlign.center,
                                      )),
                                )
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
