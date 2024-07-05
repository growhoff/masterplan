import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/archive_cubit/archive_cubit.dart';

import '../../../../domain/model/stage.dart';
import '../../../../domain/model/transfer.dart';

class DispatcherArchiveTransfersPage extends StatelessWidget {
  const DispatcherArchiveTransfersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transfersList =
        ModalRoute.of(context)?.settings.arguments as List<Transfer>;
    return DispatcherArchiveTransfersPageView(
      transfersList: transfersList,
    );
  }
}

class DispatcherArchiveTransfersPageView extends StatefulWidget {
  const DispatcherArchiveTransfersPageView(
      {required this.transfersList, super.key});

  final List<Transfer> transfersList;

  @override
  State<DispatcherArchiveTransfersPageView> createState() =>
      _DispatcherArchiveTransfersPageViewState();
}

class _DispatcherArchiveTransfersPageViewState
    extends State<DispatcherArchiveTransfersPageView> {
  @override
  void initState() {
    print(widget.transfersList.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: FittedBox(
        child: Column(
          children: [Text('переходы')],
        ),
      )),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Card(
            child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
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
                                'наименование',
                              )),
                        ),
                      ]),
                  ...List.generate(
                      widget.transfersList.length,
                      (index) => TableRow(children: [
                            TableRowInkWell(
                              onTap: () {},
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '${widget.transfersList[index].code}',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableRowInkWell(
                              onTap: () {},
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '${widget.transfersList[index].name}',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ]))
                ]),
          ),
        ),
      ),
    );
  }
}
