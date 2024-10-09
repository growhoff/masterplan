import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_analytics_page/widgets/select_area_dialog.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_analytics_page/widgets/select_date_widget.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_analytics_page/widgets/select_unit_dialog.dart';

import 'dispatcher_analytics_cubit/dispatcher_analytics_2_cubit.dart';

class DispatcherAnalyticsPage2 extends StatelessWidget {
  const DispatcherAnalyticsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DispatcherAnalytics2Cubit(),
      child: const DispatcherAnalyticsPage2View(),
    );
  }
}

class DispatcherAnalyticsPage2View extends StatefulWidget {
  const DispatcherAnalyticsPage2View({super.key});

  @override
  State<DispatcherAnalyticsPage2View> createState() =>
      _DispatcherAnalyticsPage2ViewState();
}

class _DispatcherAnalyticsPage2ViewState
    extends State<DispatcherAnalyticsPage2View> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DispatcherAnalytics2Cubit>();
    return BlocListener<DispatcherAnalytics2Cubit, DispatcherAnalytics2State>(
      listenWhen: (_, s) =>
          s is DispatcherAnalyticsSelectUnitState ||
          s is DispatcherAnalyticsSelectAreaState ||
          s is DispatcherAnalyticsSelectDateState ||
          s is DispatcherAnalyticsUploadReadyOperationsReportState,
      listener: (context, state) {
        if (state is DispatcherAnalyticsSelectUnitState) {
          showSelectUnitDialog(
              context: context, unitsList: state.unitsList, cubit: cubit);
        }
        if (state is DispatcherAnalyticsSelectAreaState) {
          showSelectAreaDialog(
              context: context, areasList: state.areasList, cubit: cubit);
        }
        if (state is DispatcherAnalyticsSelectDateState) {
          selectDateWidget(context: context, cubit: cubit);
        }

      },
      child: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
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
                        onPressed: () {
                          context
                              .read<DispatcherAnalytics2Cubit>()
                              .openUnitsFilter();
                        },
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(10))),
                        child: const Text('Цеха'),
                      ),
                      BlocBuilder<DispatcherAnalytics2Cubit,
                          DispatcherAnalytics2State>(
                        buildWhen: (_, s) =>
                            s is DispatcherAnalyticsSelectedUnitState,
                        builder: (context, state) {
                          return Text(
                            state is DispatcherAnalyticsSelectedUnitState
                                ? '${state.selectedUnit.number} ${state.selectedUnit.name}'
                                : '${cubit.selectedUnit.number} ${cubit.selectedUnit.name}',
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cubit.openAreasFilter();
                        },
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(10))),
                        child: const Text('Участки'),
                      ),
                      BlocBuilder<DispatcherAnalytics2Cubit,
                          DispatcherAnalytics2State>(
                        buildWhen: (_, s) =>
                            s is DispatcherAnalyticsSelectedAreaState ||
                            s is DispatcherAnalyticsSelectedUnitState,
                        builder: (context, state) {
                          return Text(
                            state is DispatcherAnalyticsSelectedAreaState
                                ? '${state.selectedArea.number} ${state.selectedArea.name}'
                                : '${cubit.selectedArea.number} ${cubit.selectedArea.name}',
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cubit.openDateFilter();
                        },
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(10))),
                        child: const Text('Дата'),
                      ),
                      BlocBuilder<DispatcherAnalytics2Cubit,
                          DispatcherAnalytics2State>(
                        buildWhen: (_, s) =>
                            s is DispatcherAnalyticsSelectedDateState,
                        builder: (context, state) {
                          return Text(
                            '${cubit.getDate(cubit.timeStart)} - ${cubit.getDate(cubit.timeEnd)}',
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  cubit.uploadReadyOperationsReport();
                },
                style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(10))),
                child: Text('Отчет о выполненных операциях'))
          ]),
        ),
      )),
    );
  }
}
