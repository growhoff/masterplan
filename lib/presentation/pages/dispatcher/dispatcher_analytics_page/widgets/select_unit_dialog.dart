import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/unit.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_analytics_page/dispatcher_analytics_cubit/dispatcher_analytics_2_cubit.dart';

Future<dynamic> showSelectUnitDialog(
        {required BuildContext context,
        required List<Unit> unitsList,
        required DispatcherAnalytics2Cubit cubit}) =>
    showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
              value: cubit,
              child: SimpleDialog(
                title: Text('Выберите цех'),
                children: [
                  BlocBuilder<DispatcherAnalytics2Cubit,
                      DispatcherAnalytics2State>(
                    buildWhen: (_, s) =>
                        s is DispatcherAnalyticsSelectedUnitState,
                    builder: (context, state) {
                      return DropdownButton<Unit>(
                          value: state is DispatcherAnalyticsSelectedUnitState
                              ? state.selectedUnit
                              : context
                                  .read<DispatcherAnalytics2Cubit>()
                                  .selectedUnit,
                          items: unitsList
                              .map((unit) => DropdownMenuItem(
                                  value: unit,
                                  child: Text('${unit.number} ${unit.name}')))
                              .toList(),
                          onChanged: (unit) {
                            context
                                .read<DispatcherAnalytics2Cubit>()
                                .selectUnit(unit);
                          });
                    },
                  )
                ],
              ),
            ));
