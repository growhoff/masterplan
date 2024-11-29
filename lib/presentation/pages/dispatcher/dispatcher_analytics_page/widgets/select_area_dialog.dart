import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_analytics_page/dispatcher_analytics_cubit/dispatcher_analytics_2_cubit.dart';

Future<dynamic> showSelectAreaDialog(
        {required BuildContext context,
        required List<Area> areasList,
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
                        s is DispatcherAnalyticsSelectedAreaState,
                    builder: (context, state) {
                      return DropdownButton<Area>(isExpanded: true,
                          value: state is DispatcherAnalyticsSelectedAreaState
                              ? state.selectedArea
                              : cubit.selectedArea,
                          items: areasList
                              .map((area) => DropdownMenuItem(
                                  value: area,
                                  child: Text('${area.number} ${area.name}')))
                              .toList(),
                          onChanged: (area) {
                            cubit.selectArea(area);
                          });
                    },
                  )
                ],
              ),
            ));
