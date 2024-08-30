import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringMachine/widgets/dialog_info_status.dart';
import '../bloc/cubit.dart';


class StatusItem extends StatelessWidget {
  const StatusItem(this.machine, {super.key, required this.item});
  final MonitoringMachine item;
  final Machine machine;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context,builder: (ctx) => DialogInfoStatus(item));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                children: [
                      Expanded(flex: 4, child: Row(
                        children: [
                          Container(
                            color: context.read<CubitMonitoring>().convertColor(item.statusMachine!.id),
                            width: 10,
                            height: 10,
                          ),
                          const SizedBox(width: 5),
                          Text(item.statusMachine!.name)
                        ],
                      )),
                      Expanded(flex: 2,child: Text(TimeConverter().convertTimeZone(item.timeStart))),
                      Expanded(flex: 2,child: Text(TimeConverter().convertTimeZone(item.timeStop))),
                      Expanded(flex: 2,child: Text(TimeConverter().convertTimeFromSecondsHHMMSS(item.timeWorking!))),
                      Expanded(child: Text(TimeConverter().convertIntTimeToPrecent(item.timeWorking!, machine.shiftSchedule!.timeChange * 3600))),
                ],
              ),
              // const SizedBox(height: 8),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: Visibility(
              //     visible: item.batch != null,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         Text('Деталь: ${item.batch != null ? item.batch!.number : '-'} ${item.batch != null ? item.batch!.name: ''}'),
              //         // const SizedBox(height: 8),
              //         Text(item.comment == '-' ? '' : 'Комментарий: ${item.comment}')
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}