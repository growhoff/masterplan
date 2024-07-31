import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
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
        return BlocBuilder<CubitTimer, StateTimer>(
        builder:(context, state) => Column(
          children: [
                Text(state.listRes[stateWork.activePage], style: const TextStyle(fontSize: 60)),
                Visibility(
                  visible: !error,
                  child: const SizedBox(height: 30)),
                
                Visibility(
                  visible: !error,
                  child: ButtonCircleIcon(
                        isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                        onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => QueuePage(dataPage: stateWork.pageData[activePage]))), 
                        icon: Icons.list),
                ),
                  Visibility(
                    visible: !error,
                    child: const SizedBox(height: 12)),
                  Visibility(
                    visible: !error,
                    child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButtonCastom(
                        // text: !state.listState[activePage] ? 'Начать обработку' : 'Пауза',
                        text: statusBtn == 'Все' ? 'Начать обработку' : statusBtn == 'В работе' ? 'Пауза' : 'Продолжить',
                        isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                        color: Colors.blue,
                        onPressed: () {
                            if (operActive.pause == null) {
                              context.read<CubitTimer>().firstStart(activePage, operActive.idPath);
                              context.read<CubitWork>().setStartMonitor('В работе', userId, 'Первый запуск', operActive.idPath);
                              }
                            else {
                              context.read<CubitTimer>().startOrStop(activePage, !state.listState[activePage], operActive.idPath, userId, stateWork.pageData[stateWork.activePage].machine.id, operActive.list.first.batch.id, operActive.list.first.timeFirstStart);
                              // context.read<CubitWork>().setBtnStatus(state.listState[activePage] ? 'В работе' : 'Простой');
                            }
                            
                          },
                      ),
                                    ),
                  ),
                  
          ],
        ),
      );
      }
    );
  }
}