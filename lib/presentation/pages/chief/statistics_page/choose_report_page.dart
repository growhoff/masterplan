import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/statistics_page/statictics_cubit/statistics_cubit.dart';

class ChooseReportPage extends StatelessWidget {
  const ChooseReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit(),
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
    context.read<StatisticsCubit>().fetchStagesForReport();
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
              child: BlocBuilder<StatisticsCubit, ChiefStatisticsState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              padding:
                              MaterialStateProperty.all(EdgeInsets.all(20))),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/chiefStageReport'),
                          child: const Text('Поэтапный отчет начальника')),
                      const SizedBox(height: 8),
                      ElevatedButton(
                          style: ButtonStyle(
                              padding:
                              MaterialStateProperty.all(EdgeInsets.all(20))),
                          onPressed: () {

                            context
                              .read<StatisticsCubit>()
                              .uploadOperationsReportToExcel();},
                          child: const Text('Ход выполнения операций')),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }
}
