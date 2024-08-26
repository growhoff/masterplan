import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/transfer/transfer_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
// import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/elevated_button_castom.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/state.dart';
import '../button_icon.dart';

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
          operActive = stateWork.pageData[stateWork.activePage].operActive!;
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonCircleIcon(
                            isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                            onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => QueuePage(dataPage: stateWork.pageData[activePage]))), 
                            icon: Icons.list,
                          ),
                          const SizedBox(width: 20),
                          ButtonCircleIcon(
                            isActive: true,
                            onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => TransferPage(operation: stateWork.pageData[activePage].operActive))), 
                            icon: Icons.transfer_within_a_station,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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