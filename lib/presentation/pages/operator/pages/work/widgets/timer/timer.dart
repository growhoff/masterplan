import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/usecase/button_status.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_input_comment.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_input_work.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/elevated_button_castom.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/state.dart';


class Time extends StatelessWidget {
  const Time(this.error, {super.key});
  final bool error;
  @override
  Widget build(BuildContext context) {
    final userId = context.read<CubitMain>().state.user!.id;
    return BlocBuilder<CubitWork,StateWork>(
      builder:(context, stateWork) {
        var activePage;
        var statusBtn;
        var operActive;
        if (!error){
          activePage = stateWork.activePage;
          statusBtn = stateWork.statusBtn[activePage];
          operActive = stateWork.pageData[stateWork.activePage].operActive ?? stateWork.pageData[stateWork.activePage].operQueueList.first;
        } 
        // else {operActive = ItemOperOp(list: [], listId: [], idPath: 0, machineId: 0, statusId: 0, order: 0, listChiefBatchId: [], listChiefOperationId: []);}
        // activePage = stateWork.activePage;
        // statusBtn = stateWork.statusBtn[activePage];

        return BlocBuilder<CubitTimer, StateTimer>(
        builder:(context, state) => Column(
          children: [
                Text(state.listRes[stateWork.activePage], style: const TextStyle(fontSize: 60)),
                !error ? Visibility(
                  visible: !error,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const Expanded(flex: 2, child: Text('Статус:')),
                            Expanded(flex: 3, child: Text(statusBtn == 'Все' ? 'Простой' : statusBtn, style: TextStyle(color: ButtonStatus().getColorStatus(statusBtn), fontWeight: FontWeight.w700), textAlign: TextAlign.start,)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButtonCastom(
                            text: context.read<CubitWork>().getButtonName(operActive.list.first.listTransfer, statusBtn),
                            isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                            color: Colors.blue,
                            onPressed: () {
                                if (operActive.pause == null) {
                                  context.read<CubitTimer>().firstStart(activePage, operActive);
                                  context.read<CubitWork>().setStartMonitor('В работе', userId, 'Первый запуск', operActive.idPath);
                                  if (operActive.list.first.listTransfer!.isNotEmpty) context.read<CubitTimer>().firstStartTransfer(operActive, stateWork.pageData[stateWork.activePage].machine.id, userId, stateWork.activeTransfer, stateWork.activeTransfer);
                                } else {
                                  context.read<CubitTimer>().startOrStop(activePage, !state.listState[activePage], operActive.idPath, userId, stateWork.pageData[stateWork.activePage].machine.id, operActive.list.first.batch.id, operActive.list.first.timeFirstStart);
                                  // context.read<CubitWork>().setBtnStatus(state.listState[activePage] ? 'В работе' : 'Простой');
                                  if (operActive.list.first.listTransfer!.isNotEmpty) {
                                    if (stateWork.newTransfer) {
                                      context.read<CubitTimer>().firstStartTransfer(operActive, stateWork.pageData[stateWork.activePage].machine.id, userId, stateWork.activeTransfer, stateWork.activeTransfer);
                                      context.read<CubitWork>().toggleNewTransfer();
                                    } else {
                                      context.read<CubitTimer>().startOrStopTransfer(!state.listState[activePage], operActive, userId, stateWork.activeTransfer);
                                    }
                                  }
                                }
                              },
                          ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButtonCastom(
                              text: 'Брак: ${stateWork.count}',
                              isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                              color: const Color.fromARGB(255, 61, 16, 222),
                              onPressed: () {
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext innerContext){
                                    return BlocProvider.value(
                                      value: context.watch<CubitWork>(),
                                      child: Material(
                                        child: BlocBuilder<CubitWork, StateWork>(
                                          builder: (context, state) => DialogInputWork(count: operActive!.list.length, indexOper: 1),
                                        )
                                      ),
                                      );
                                  });
                      })),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButtonCastom(
                          text: operActive.list.first.listTransfer!.isEmpty ? 'Деталь готова' : 'Переход готов',
                          isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                          color: Colors.green,
                          onPressed: () async{
                            String? val = '';
                            val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());
                            if (val != ''){
                              if (stateWork.count > 0){ 
                                if (context.mounted) context.read<CubitWork>().setBrak(operActive!, context.read<CubitTimer>().state.listTick[activePage], val!);
                              } else {
                                if (context.mounted) {
                                  if (operActive!.list.first.listTransfer!.isEmpty) {context.read<CubitWork>().setReady(operActive, context.read<CubitTimer>().state.listTick[activePage], val!);}
                                  else {context.read<CubitWork>().setReadyTransfer(operActive, context.read<CubitTimer>().state.listTick[activePage], val!);}
                                }
                              }
                              if (context.mounted) context.read<CubitTimer>().refresh(activePage);
                            }
                          },
                        )),
                    ],
                  )
                ) : const Text(''),
          ],
        ),
      );
      }
    );
  }
}