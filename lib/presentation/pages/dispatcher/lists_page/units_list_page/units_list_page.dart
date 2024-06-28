import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/units_list_page/units_cubit/units_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/units_list_page/widgets/table_row_element.dart';

class UnitsListPage extends StatelessWidget {
  const UnitsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnitsCubit(),
      child: const UnitsListPageView(),
    );
  }
}

class UnitsListPageView extends StatefulWidget {
  const UnitsListPageView({super.key});

  @override
  State<UnitsListPageView> createState() => _UnitsListPageViewState();
}

class _UnitsListPageViewState extends State<UnitsListPageView> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    context.read<UnitsCubit>().fetchUnits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('список цехов'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dispatcherAddUnitPage')
                        .then((_) => setState(() {
                              context.read<UnitsCubit>().fetchUnits();
                            }));
                  },
                  icon: Icon(
                    Icons.add_rounded,
                    size: 30,
                  )),
            )
          ],
        ),
        body: BlocBuilder<UnitsCubit, UnitsState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1.5),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                      6: FlexColumnWidth(2),
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
                                    'номер цеха',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'название',
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'кол-во участков',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'кол-во рабочих',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'кол-во оборудования',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'кол-во вспомогательного персонала',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            TableCell(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'начальник цеха',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ]),
                      ...List.generate(
                          state.unitsList.length,
                          (index) => TableRow(children: [
                                UnitsTableRowElement(
                                  '${state.unitsList[index].number}',
                                  unit: state.unitsList[index],
                                  fetchUnits: () => setState(() {
                                    context.read<UnitsCubit>().fetchUnits();
                                  }),
                                ),
                                UnitsTableRowElement(
                                  '${state.unitsList[index].name}',
                                  unit: state.unitsList[index],
                                  fetchUnits: () => setState(() {
                                    context.read<UnitsCubit>().fetchUnits();
                                  }),
                                ),
                                UnitsTableRowElement(
                                  '${state.unitsList[index].areasQuantity}',
                                  unit: state.unitsList[index],
                                  fetchUnits: () => setState(() {
                                    context.read<UnitsCubit>().fetchUnits();
                                  }),
                                ),
                                UnitsTableRowElement(
                                  '${state.unitsList[index].operatorsQuantity}',
                                  unit: state.unitsList[index],
                                  fetchUnits: () => setState(() {
                                    context.read<UnitsCubit>().fetchUnits();
                                  }),
                                ),
                                UnitsTableRowElement(
                                  '${state.unitsList[index].machinesQuantity}',
                                  unit: state.unitsList[index],
                                  fetchUnits: () => setState(() {
                                    context.read<UnitsCubit>().fetchUnits();
                                  }),
                                ),
                                UnitsTableRowElement(
                                  '${state.unitsList[index].supportStaffQuantity}',
                                  unit: state.unitsList[index],
                                  fetchUnits: () => setState(() {
                                    context.read<UnitsCubit>().fetchUnits();
                                  }),
                                ),
                                UnitsTableRowElement(
                                  '${state.unitsList[index].chief?.user.fio}',
                                  unit: state.unitsList[index],
                                  fetchUnits: () => setState(() {
                                    context.read<UnitsCubit>().fetchUnits();
                                  }),
                                ),
                              ]))
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
