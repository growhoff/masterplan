import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chief_areas_cubit/chief_areas_cubit.dart';
import 'chief_areas_page_widgets/areas_table_row_dialog.dart';


class ChiefAreasPage extends StatelessWidget {
  const ChiefAreasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefAreasCubit(),
      child: const ChiefAreasPageView(),
    );
  }
}

class ChiefAreasPageView extends StatefulWidget {
  const ChiefAreasPageView({super.key});

  @override
  State<ChiefAreasPageView> createState() => _ChiefAreasPageViewState();
}

class _ChiefAreasPageViewState extends State<ChiefAreasPageView> {
  @override
  void initState() {
    context.read<ChiefAreasCubit>().fetchAreas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('список участков'),
        ),
        body: BlocBuilder<ChiefAreasCubit, ChiefAreasState>(
            builder: (context, state) {
          if (state is ChiefRegionsSuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => {Navigator.pushNamed(context, '/chiefAreaInsertPage')},
                      child: Text('добавить'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(3)
                      },
                      defaultColumnWidth: FlexColumnWidth(),
                      border: TableBorder.all(color: Colors.black),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                            decoration: BoxDecoration(color: Colors.grey),
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'номер участка',
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
                                      'кол-во оборудования',
                                      textAlign: TextAlign.center,
                                    )),
                              )
                            ]),
                        ...List.generate(
                            state.areas.length,
                            (index) => TableRow(children: [
                                  TableRowInkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AreasTableDialog(
                                            area: state.areas[index],
                                            deleteRegion: () => context
                                                .read<ChiefAreasCubit>()
                                                .deleteArea(
                                                    areaId: state
                                                        .areas[index].id)
                                          ),
                                      );
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${state.areas[index].number}',
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  TableRowInkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AreasTableDialog(
                                            area: state.areas[index],
                                            deleteRegion: () => context
                                                .read<ChiefAreasCubit>()
                                                .deleteArea(
                                                    areaId: state
                                                        .areas[index].id),
                                           ),
                                      );
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${state.areas[index].name}',
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  TableRowInkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AreasTableDialog(
                                            area: state.areas[index],
                                            deleteRegion: () => context
                                                .read<ChiefAreasCubit>()
                                                .deleteArea(
                                                    areaId: state
                                                        .areas[index].id),
                                        ),
                                      );
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${state.areas[index].machinesQuantity}',
                                          textAlign: TextAlign.center,
                                        )),
                                  )
                                ]))
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
