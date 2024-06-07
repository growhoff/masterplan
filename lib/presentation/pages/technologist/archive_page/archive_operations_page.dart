import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/archive_cubit/archive_cubit.dart';

import '../../../../domain/model/stage.dart';

class ArchiveOperationsPage extends StatelessWidget {
  const ArchiveOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stage = ModalRoute.of(context)!.settings.arguments as Stage;
    return BlocProvider(
      create: (context) => ArchiveCubit(),
      child: ArchiveOperationsPageView(
        stage: stage,
      ),
    );
  }
}

class ArchiveOperationsPageView extends StatefulWidget {
  final Stage stage;

  const ArchiveOperationsPageView({required this.stage, super.key});

  @override
  State<ArchiveOperationsPageView> createState() =>
      _ArchiveOperationsPageViewState();
}

class _ArchiveOperationsPageViewState extends State<ArchiveOperationsPageView> {
  @override
  void initState() {
    context.read<ArchiveCubit>().fetchOperations(stageId: widget.stage.id);
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
              '${widget.stage.number} ${widget.stage.name}',
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
                                  onTap: () {
                                    context.read<ArchiveCubit>().fetchTransfers(
                                        operationId:
                                            state.operationsList[index].id);

                                    if (state.transfersList.isNotEmpty){
                                      Navigator.pushNamed(
                                          context, '/archiveTransferPage',
                                          arguments: state.transfersList);
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                          content:
                                          Text('переходов нет')));
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
                                  onTap: () {
                                    context.read<ArchiveCubit>().fetchTransfers(
                                        operationId:
                                        state.operationsList[index].id);

                                    if (state.transfersList.isNotEmpty){
                                      Navigator.pushNamed(
                                          context, '/archiveTransferPage',
                                          arguments: state.transfersList);
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                          Text('переходов нет')));
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
                                  onTap: () {
                                    context.read<ArchiveCubit>().fetchTransfers(
                                        operationId:
                                        state.operationsList[index].id);

                                    if (state.transfersList.isNotEmpty){
                                      Navigator.pushNamed(
                                          context, '/archiveTransferPage',
                                          arguments: state.transfersList);
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                          Text('переходов нет')));
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
