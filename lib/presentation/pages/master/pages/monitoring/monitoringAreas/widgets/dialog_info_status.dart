import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';

class DialogInfoStatus extends StatelessWidget {
  const DialogInfoStatus(this.item, {super.key});
  final MonitoringMachine item;
  @override
  Widget build(BuildContext context) {   
    return AlertDialog(
                title: Text('Информация о статусе: ${item.statusMachine!.name}'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    item.firstStartBatch == null
                    ? const Text('Первый запуск: -')
                    : Text('Первый запуск: ${TimeConverter().getStringDataFromInt(item.firstStartBatch!)}'),
                    const SizedBox(height: 8),

                    Text('Начало: ${TimeConverter().convertTimeZone(item.timeStart)}'),
                    const SizedBox(height: 8),
                    Text('Конец: ${TimeConverter().convertTimeZone(item.timeStop)}'),
                    const SizedBox(height: 8),
                    Text('Общее: ${TimeConverter().convertTimeFromSecondsHHMMSS(item.timeWorking!)}'),
                    const SizedBox(height: 8),

                    item.batch != null 
                      ? Text('Деталь: ${item.batch!.number} ${item.batch!.name}')
                      : const Text('Деталь: -'),
                    const SizedBox(height: 8),
                    Text('Комментарий: ${item.comment}'),
                    const SizedBox(height: 8),
                    Text('Идентификатор опт.партии: ${item.operationId}'),
                    const SizedBox(height: 8),
                  ],
                ),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
            );
}
}