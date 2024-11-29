import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/cubit/analytics_cubit.dart';

import '../../../../domain/model/area.dart';
import '../../../../domain/model/machine.dart';
import '../../../../domain/model/unit.dart';
import '../../../app/bloc/cubit.dart';
import 'dispatcher_analytics_cubit/dispatcher_analytics_cubit.dart';

class DispatcherAnalyticsPage extends StatelessWidget {
  const DispatcherAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DispatcherAnalyticsCubit(),
      child: const DispatcherAnalyticsPageView(),
    );
  }
}

class DispatcherAnalyticsPageView extends StatefulWidget {
  const DispatcherAnalyticsPageView({super.key});

  @override
  State<DispatcherAnalyticsPageView> createState() =>
      _DispatcherAnalyticsPageViewState();
}

class _DispatcherAnalyticsPageViewState
    extends State<DispatcherAnalyticsPageView> {
  @override
  void initState() {
    context.read<DispatcherAnalyticsCubit>().fetchUnits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<DispatcherAnalyticsCubit, DispatcherAnalyticsState>(
          builder: (context, state) {
        if (state.status == DispatcherAnalyticsStateStatus.success) {
          return Center(
              child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 1,
                ),
                const Text('фильтры'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(10))),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => StatefulBuilder(
                                          builder: (ctx, setStateLocal) {
                                        return SimpleDialog(
                                          title: const Text('Выберите цех'),
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                alignment: Alignment.center,
                                                child: DropdownButton<Unit>(
                                                    value: context
                                                        .read<
                                                            DispatcherAnalyticsCubit>()
                                                        .selectedUnit,
                                                    items: state.unitsList
                                                        .map((Unit unit) =>
                                                            DropdownMenuItem(
                                                              value: unit,
                                                              child: Text(
                                                                  '${unit.number} ${unit.name}'),
                                                            ))
                                                        .toList(),
                                                    onChanged: (Unit? value) =>
                                                        setStateLocal(() {
                                                          context
                                                              .read<
                                                                  DispatcherAnalyticsCubit>()
                                                              .changeSelectedUnit(
                                                                  value ??
                                                                      Unit.empty);

                                                          context
                                                              .read<
                                                                  DispatcherAnalyticsCubit>()
                                                              .fetchAreas();

                                                          context
                                                                  .read<
                                                                      DispatcherAnalyticsCubit>()
                                                                  .selectedArea =
                                                              Area.empty;
                                                        }))),
                                          ],
                                        );
                                      }));
                            },
                            child: const Text('цех'),
                          ),
                          Text(
                              textAlign: TextAlign.center,
                              softWrap: true,
                              '${context.read<DispatcherAnalyticsCubit>().selectedUnit.number} ${context.read<DispatcherAnalyticsCubit>().selectedUnit.name}'),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(10))),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => StatefulBuilder(
                                        builder: (ctx, setState) {
                                          return SimpleDialog(
                                            title:
                                                const Text('Выберите участок'),
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                alignment: Alignment.center,
                                                child: DropdownButton<Area>(
                                                    value: context
                                                        .read<
                                                            DispatcherAnalyticsCubit>()
                                                        .selectedArea,
                                                    items: state.areasList
                                                        .map((Area area) =>
                                                            DropdownMenuItem(
                                                              value: area,
                                                              child: Text(
                                                                  '${area.number} ${area.name}'),
                                                            ))
                                                        .toList(),
                                                    onChanged: (Area? value) =>
                                                        setState(() {
                                                          context
                                                                  .read<
                                                                      DispatcherAnalyticsCubit>()
                                                                  .selectedArea =
                                                              value ??
                                                                  Area.empty;

                                                          context
                                                              .read<
                                                                  DispatcherAnalyticsCubit>()
                                                              .addSelectedAreaToList(
                                                                  value ??
                                                                      Area.empty);

                                                          print(
                                                              '${context.read<DispatcherAnalyticsCubit>().selectedArea.number} ${context.read<DispatcherAnalyticsCubit>().selectedArea.name}');
                                                        }),
                                                    isExpanded: true),
                                              ),
                                            ],
                                          );
                                        },
                                      ));
                            },
                            child: const Text('участок'),
                          ),
                          Text(
                              textAlign: TextAlign.center,
                              softWrap: true,
                              '${context.read<DispatcherAnalyticsCubit>().selectedArea.number} ${context.read<DispatcherAnalyticsCubit>().selectedArea.name}'),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(10))),
                            onPressed: () async {
                              await context
                                  .read<DispatcherAnalyticsCubit>()
                                  .fetchTime(context);
                              print(context
                                  .read<DispatcherAnalyticsCubit>()
                                  .timeStart);
                              print(context
                                  .read<DispatcherAnalyticsCubit>()
                                  .timeEnd);
                              setState(() {});
                            },
                            child: const Text('дата'),
                          ),
                          Text(
                              textAlign: TextAlign.center,
                              softWrap: true,
                              '${context.read<DispatcherAnalyticsCubit>().getDate(context.read<DispatcherAnalyticsCubit>().timeStart)} - ${context.read<DispatcherAnalyticsCubit>().getDate(context.read<DispatcherAnalyticsCubit>().timeEnd)}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(10))),
                  onPressed: () async {
                    context
                        .read<DispatcherAnalyticsCubit>()
                        .uploadReadyOperationsReport();
                  },
                  child: const Text('Отчет о выполненных операциях'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(10))),
                  onPressed: () async {
                    context
                        .read<DispatcherAnalyticsCubit>()
                        .uploadTotalNumberReadyOperationsReport();
                  },
                  child: const Text(
                    'Отчет\nсуммарного количества\nвыполненных операций',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(10))),
                  onPressed: () async {
                    context
                        .read<DispatcherAnalyticsCubit>()
                        .uploadMonitoringStatusesReport();

                    // await context
                    //     .read<DispatcherAnalyticsCubit>()
                    //     .fetchMachines();
                    //
                    // print('machines list from page : ${state.machinesList}');
                    //
                    // await showDialog(
                    //     context: context,
                    //     builder: (ctx) => Dialog(
                    //           child: Container(
                    //             padding: const EdgeInsets.all(10),
                    //             child: Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               children: [
                    //                 const Text('Оборудование'),
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 DropdownButton<Machine>(
                    //                     value: context
                    //                         .read<DispatcherAnalyticsCubit>()
                    //                         .selectedMachine,
                    //                     hint: const Text('все'),
                    //                     items: state.machinesList
                    //                         .map((Machine machine) =>
                    //                             DropdownMenuItem(
                    //                                 value: machine,
                    //                                 child: Text(
                    //                                     '${machine.inventoryNumber} ${machine.name}')))
                    //                         .toList(),
                    //                     onChanged: (_) {}),
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 const Text('Смена'),
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 const Text('Оператор'),
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 const Text('Статус'),
                    //                 const SizedBox(
                    //                   height: 20,
                    //                 ),
                    //                 ElevatedButton(
                    //                     onPressed: () {
                    //                       context
                    //                           .read<DispatcherAnalyticsCubit>()
                    //                           .uploadMonitoringStatusesReport();
                    //                     },
                    //                     child: const Text('вывести отчет'))
                    //               ],
                    //             ),
                    //           ),
                    //         ));
                  },
                  child: const Text(
                    'Статусы мониторинга',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
