import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

// import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/cubit/analytics_cubit.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => AnalyticsCubit(),
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
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
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
                            onPressed: () async {
                              await context
                                  .read<AnalyticsCubit>()
                                  .fetchTime(context);
                              print(context.read<AnalyticsCubit>().timeStart);
                              print(context.read<AnalyticsCubit>().timeEnd);
                              setState(() {});
                            },
                            child: Text('дата'),
                          ),
                          Text(
                              textAlign: TextAlign.center,
                              softWrap: true,
                              '${context.read<AnalyticsCubit>().getDate(context.read<AnalyticsCubit>().timeStart)} - ${context.read<AnalyticsCubit>().getDate(context.read<AnalyticsCubit>().timeEnd)}'),
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
                        .read<AnalyticsCubit>()
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
          ),
        );
      },
    );
  }
}
