import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/cubit/analytics_cubit.dart';

import '../../../../domain/model/area.dart';
import '../../../../domain/model/unit.dart';
import 'dispatcher_analytics_cubit/dispatcher_analytics_cubit.dart';

class DispatcherAnalyticsPage extends StatelessWidget {
  const DispatcherAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DispatcherAnalyticsCubit(),
      child: DispatcherAnalyticsPageView(),
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
    context.read<DispatcherAnalyticsCubit>().fetchAreas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DispatcherAnalyticsCubit, DispatcherAnalyticsState>(
      builder: (context, state) {
        return Center(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Divider(
                height: 1,
              ),
              Text('фильтры'),
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
                                  EdgeInsets.all(10))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => StatefulBuilder(
                                        builder: (ctx, setStateLocal) {
                                      return SimpleDialog(
                                        title: Text('Выберите цех'),
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(10),
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

                                                        print(context.read<DispatcherAnalyticsCubit>().selectedAreasList);
                                                      }))),
                                        ],
                                      );
                                    }));
                          },
                          child: Text('цех'),
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
                                  EdgeInsets.all(10))),
                          onPressed: () {
                            setState(() {
                              context
                                  .read<DispatcherAnalyticsCubit>()
                                  .pressAreasButton();
                            });
                            showDialog(
                                context: context,
                                builder: (ctx) => StatefulBuilder(
                                      builder: (ctx, setState) {
                                        return SimpleDialog(
                                          title: Text('Выберите участок'),
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
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
                                                            value ?? Area.empty;

                                                        context
                                                            .read<
                                                                DispatcherAnalyticsCubit>()
                                                            .addSelectedAreaToList();

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
                          child: Text('участок'),
                        ),
                        Text(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            '${context.read<DispatcherAnalyticsCubit>().selectedArea.number != '' ? context.read<DispatcherAnalyticsCubit>().selectedArea.number : 'все в выбранном цехе'} ${context.read<DispatcherAnalyticsCubit>().selectedArea.name}'),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10))),
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
                          child: Text('дата'),
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
              Divider(
                height: 1,
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10))),
                onPressed: () async {
                  context
                      .read<DispatcherAnalyticsCubit>()
                      .uploadReadyOperationsReport();
                },
                child: Text('Отчет о выполненных операциях'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10))),
                onPressed: () async {
                  context
                      .read<DispatcherAnalyticsCubit>()
                      .uploadTotalNumberReadyOperationsReport();
                },
                child: Text(
                  'Отчет\nсуммарного количества\nвыполненных операций',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
