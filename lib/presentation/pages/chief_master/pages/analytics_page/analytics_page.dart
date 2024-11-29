import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './cubit/analytics_cubit.dart';

class AnalyticsPageChM extends StatelessWidget {
  const AnalyticsPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    final staffId = context.read<CubitMain>().state.user?.id ?? 0;
    return BlocProvider(
      create: (context) => AnalyticsCubit(staffId),
      child: AnalyticsPageView(),
    );
  }
}

class AnalyticsPageView extends StatefulWidget {
  @override
  State<AnalyticsPageView> createState() => _AnalyticsPageViewState();
}

class _AnalyticsPageViewState extends State<AnalyticsPageView> {
  @override
  void initState() {
    context.read<AnalyticsCubit>().fetchStagesForReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        if (state.status == AnalyticsPageStatus.success) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10))),
                  onPressed: () {
                    context
                        .read<AnalyticsCubit>()
                        .uploadReadyOperationsReport(context);
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
                  onPressed: () { context
                      .read<AnalyticsCubit>()
                      .uploadStagesReportToExcel();},
                  child: Text('Поэтапный отчет начальника'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10))),
                  onPressed: () {context
                      .read<AnalyticsCubit>()
                      .uploadOperationsReportToExcel();},
                  child: Text('Ход выполнения операций'),
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
                        .read<AnalyticsCubit>()
                        .uploadTotalNumberReadyOperationsReport(context);
                  },
                  child: Text(
                    'Отчет\nсуммарного количества\nвыполненных операций',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
