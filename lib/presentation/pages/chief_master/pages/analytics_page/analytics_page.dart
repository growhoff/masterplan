import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './cubit/analytics_cubit.dart';

class AnalyticsPageChM extends StatelessWidget {
  const AnalyticsPageChM({super.key});

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
          child: ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.all(10))),
            onPressed: () {context.read<AnalyticsCubit>().uploadReadyOperationsReport();},
            child: Text('Выполненные операции (отчет)'),
          ),
        );
      },
    );
  }
}
