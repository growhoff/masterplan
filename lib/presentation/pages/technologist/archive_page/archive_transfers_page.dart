import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/batches_page/batches_cubit/batches_cubit.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/archive_cubit/archive_cubit.dart';

import '../../../../domain/model/transfer_archive.dart';

class DispatcherArchiveTransfersPage extends StatelessWidget {
  const DispatcherArchiveTransfersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit =
        ModalRoute.of(context)?.settings.arguments as ArchiveCubit;
    return DispatcherArchiveTransfersPageView(
      cubit: cubit,
    );
  }
}

class DispatcherArchiveTransfersPageView extends StatefulWidget {
  const DispatcherArchiveTransfersPageView(
      {required this.cubit, super.key});

  final ArchiveCubit cubit;

  @override
  State<DispatcherArchiveTransfersPageView> createState() =>
      _DispatcherArchiveTransfersPageViewState();
}

class _DispatcherArchiveTransfersPageViewState
    extends State<DispatcherArchiveTransfersPageView> {
  @override
  void initState() {

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
                      widget.cubit.state.transfersList.length,
                      (index) => TableRow(children: [
                            TableRowInkWell(
                              onTap: () {},
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '${widget.cubit.state.transfersList[index].code}',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableRowInkWell(
                              onTap: () {},
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '${widget.cubit.state.transfersList[index].name}',
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
