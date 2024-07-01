import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/statistics_page/statictics_cubit/statistics_cubit.dart';

class ChiefStatisticsPage extends StatelessWidget {
  const ChiefStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit(),
      child: ChiefStatisticsPageView(),
    );
  }
}

class ChiefStatisticsPageView extends StatefulWidget {
  const ChiefStatisticsPageView({
    super.key,
  });

  @override
  State<ChiefStatisticsPageView> createState() =>
      _ChiefMonitoringPageViewState();
}

class _ChiefMonitoringPageViewState extends State<ChiefStatisticsPageView> {
  int activeIndex = 0;

  @override
  void initState() {
    context.read<StatisticsCubit>().fetchStagesForReport();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поэтапный отчет'),
      ),
      body: SafeArea(child: BlocBuilder<StatisticsCubit, ChiefStatisticsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<StatisticsCubit>()
                          .uploadStagesReportToExcel();
                    },
                    child: Text('выгрузить отчет')),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, '/chiefOperationsStatisticsPage',
                                arguments: state.stagesList[index]),
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Этап №${state.stagesList[index].stageNumber}'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            'Чертеж ${state.stagesList[index].batchNumber}\n${state.stagesList[index].batchName}'),
                                      ),
                                      Text(
                                          'Код детали: ${state.stagesList[index].batchCode}'),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text('Детали'),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                          'кол-во: ${state.stagesList[index].detailsQuantity}')
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Выполненно: ${state.stagesList[index].readyDetailsQuantity}'),
                                      Text(
                                          '${state.stagesList[index].readyDetailsPercent}%'),
                                      Text(
                                          'Бракованных: ${state.stagesList[index].defectDetailsQuantity}'),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text('Операции'),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                          'кол-во: ${state.stagesList[index].operationsQuantity}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Выполнено: ${state.stagesList[index].readyOperationsQuantity}'),
                                      Text(
                                          '${state.stagesList[index].readyOperationsPercent}%'),
                                    ],
                                  )
                                ],
                              ),
                            )),
                          ),
                      separatorBuilder: (context, i) => SizedBox(
                            height: 10,
                          ),
                      itemCount: state.stagesList.length),
                ),
              )
            ],
          );
        },
      )),
    );
  }
}
