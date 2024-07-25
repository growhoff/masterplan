import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chief_analytics_page/analytics_cubit/analytics_cubit.dart';

class ChooseReportPage extends StatelessWidget {
  const ChooseReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsCubit(),
      child: const ChooseReportPageView(),
    );
  }
}

class ChooseReportPageView extends StatefulWidget {
  const ChooseReportPageView({super.key});

  @override
  State<ChooseReportPageView> createState() => _ChooseReportPageViewState();
}

class _ChooseReportPageViewState extends State<ChooseReportPageView> {
  @override
  void initState() {
    context.read<AnalyticsCubit>().fetchStagesForReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(16),
            width: double.maxFinite,
            child: Center(
              child: BlocBuilder<AnalyticsCubit, ChiefAnalyticsState>(
                builder: (context, state) {
                  if (state.status == AnalyticsPageStatus.success) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.all(20))),
                            onPressed: () {
                              context
                                  .read<AnalyticsCubit>()
                                  .uploadStagesReportToExcel();
                            },
                            child: const Text('Поэтапный отчет начальника')),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.all(20))),
                            onPressed: () {
                              context
                                  .read<AnalyticsCubit>()
                                  .uploadOperationsReportToExcel();
                            },
                            child: const Text('Ход выполнения операций')),
                        const SizedBox(height: 8),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )),
      ),
    );
  }
}
