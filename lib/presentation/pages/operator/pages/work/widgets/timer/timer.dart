import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/usecase/button_status.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
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
        int activePage;
        String statusBtn;
        ItemOperOp? operActive;
        if (!error){
          statusBtn = stateWork.statusBtn[stateWork.activePage];
          operActive = stateWork.pageData[stateWork.activePage].operActive ?? stateWork.pageData[stateWork.activePage].operQueueList.first;
        } else{
          statusBtn = stateWork.statusBtn[stateWork.activePage];
        }
        activePage = stateWork.activePage;
        
        return BlocBuilder<CubitTimer, StateTimer>(
        builder:(context, state) => Column(
          children: [
                Text(state.listRes[stateWork.activePage], style: const TextStyle(fontSize: 60)),
                Row(
                  children: [
                    const Expanded(flex: 2, child: Text('Статус:')),
                    Expanded(flex: 3, child: Text(statusBtn == 'Все' ? 'Простой' : statusBtn, style: TextStyle(color: ButtonStatus().getColorStatus(statusBtn), fontWeight: FontWeight.w700), textAlign: TextAlign.start,)),
                  ],
                ),
                
                !error ? Visibility(
                  visible: !error,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      operActive!.list.first.listTransfer!.isEmpty
                        //первая верстка при отсуствии переходов
                        ? Column(
                          children: [
                            operActive.pause == null 
                            ? SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButtonCastom(
                                icon: Icons.play_arrow_sharp,
                                text: 'Начать обработку детали',
                                isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                color: Colors.blue,
                                onPressed: () {
                                    context.read<CubitTimer>().firstStart(activePage, operActive!);
                                    context.read<CubitWork>().setStartMonitor('В работе', userId, 'Первый запуск', operActive.idPath);
                                  },
                              ),
                            )
                            : SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButtonCastom(
                                  icon: statusBtn == 'Простой' ? Icons.play_arrow_sharp : Icons.pause,
                                  text: statusBtn == 'Простой' ? 'Продолжить' : 'Пауза',
                                  isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                  color: Colors.blue,
                                  onPressed: () {
                                      context.read<CubitTimer>().startOrStop(index: activePage, isStart: !state.listState[activePage], idOptPath:  operActive!.idPath, userId: userId, batchId: operActive.list.first.batch.id, firstTimeBatch: operActive.list.first.timeFirstStart, machine: stateWork.pageData[stateWork.activePage].machine);
                                    },
                                ),
                              ),

                              SizedBox(height: operActive.pause != true ? 8: 0),
                              operActive.pause != null ? Visibility(
                                visible: operActive.pause != true,
                                child: SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButtonCastom(
                                        icon: Icons.do_not_disturb,
                                        text: 'Брак',//${stateWork.count}
                                        isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                        color: const Color.fromARGB(255, 222, 16, 16),
                                        onPressed: () async{
                                          String? val = '';
                                          val = await showDialog<String>(context: context,builder: (BuildContext context) => DialogInputWork(count: operActive!.list.length, indexOper: 1));
                                          if (val != '' && context.mounted) {
                                            context.read<CubitWork>().setBrak(operActive!, context.read<CubitTimer>().state.listTick[activePage], val!, false);
                                            context.read<CubitTimer>().refresh(activePage);
                                          }
                                })),
                              ) : Container(),


                              SizedBox(height: operActive.pause != true ? 8: 0),
                              operActive.pause != true ? SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButtonCastom(
                                  icon: Icons.flag,
                                  text: 'Деталь готова',
                                  isActive: operActive.pause != null && (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                  color: operActive.pause != null ? Colors.green : Colors.white70,
                                  onPressed: () async{
                                    String? val = '';
                                    val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());
                                    if (val != ''){
                                      if (context.mounted) context.read<CubitWork>().setReady(operActive!, context.read<CubitTimer>().state.listTick[activePage], val!);
                                      if (context.mounted) context.read<CubitTimer>().refresh(activePage);
                                    }
                                  },
                                )) : Container(),

                          ],
                        )
                      //вторая верстка с переходами
                      : Column(
                          children: [
                            operActive.pause == null 
                              ? SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButtonCastom(
                                  icon: Icons.play_arrow_sharp,
                                  text: 'Начать обработку детали',
                                  isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                  color: Colors.blue,
                                  onPressed: () {
                                      context.read<CubitTimer>().firstStart(activePage, operActive!);
                                      context.read<CubitWork>().setStartMonitor('В работе', userId, 'Первый запуск', operActive.idPath);
                                      context.read<CubitTimer>().firstStartTransfer(operActive, stateWork.pageData[stateWork.activePage].machine.id, userId, stateWork.activeTransfer, stateWork.activeTransfer);
                                    },
                                ),
                              )
                              : SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButtonCastom(
                                    icon: statusBtn == 'Простой' ? Icons.play_arrow_sharp : Icons.pause,
                                    text: statusBtn == 'Простой' ? 'Продолжить' : 'Пауза',
                                    isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                    color: Colors.blue,
                                    onPressed: () {
                                        context.read<CubitTimer>().startOrStop(index: activePage, isStart: !state.listState[activePage], idOptPath:  operActive!.idPath, userId: userId, batchId: operActive.list.first.batch.id, firstTimeBatch: operActive.list.first.timeFirstStart, machine: stateWork.pageData[stateWork.activePage].machine);
                                        if (stateWork.newTransfer) {
                                          context.read<CubitTimer>().firstStartTransfer(operActive, stateWork.pageData[stateWork.activePage].machine.id, userId, stateWork.activeTransfer, stateWork.activeTransfer);
                                          context.read<CubitWork>().toggleNewTransfer();
                                        } else {
                                          context.read<CubitTimer>().startOrStopTransfer(!state.listState[activePage], operActive, userId, stateWork.activeTransfer);
                                        }
                                      },
                                  ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Переход ${stateWork.activeTransfer + 1}: ${operActive.list.first.listTransfer![stateWork.activeTransfer].name}'),
                                  Text('Т шт. = ${operActive.list.first.listTransfer![stateWork.activeTransfer].timesh}')
                                ],
                              ),


                              operActive.pause == false && operActive.list.first.listTransfer!.isNotEmpty && operActive.list.first.listTransfer!.length != stateWork.activeTransfer + 1 ? SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButtonCastom(
                                icon: Icons.skip_next,
                                text: 'Следующий переход',
                                isActive: operActive.pause != null && (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                color: operActive.pause != null ? Colors.lightGreen : Colors.white70,
                                onPressed: () async{
                                  context.read<CubitWork>().setReadyTransfer(operActive!, context.read<CubitTimer>().state.listTick[activePage], '');
                                  context.read<CubitWork>().toggleNewTransfer();
                                  context.read<CubitTimer>().refreshNext(activePage);
                                  context.read<CubitTimer>().firstStartTransfer(operActive, stateWork.pageData[stateWork.activePage].machine.id, userId, stateWork.activeTransfer, stateWork.activeTransfer);
                                  
                                },
                              )) : Container(),


                              SizedBox(height: operActive.pause != true ? 8: 0),
                              operActive.pause != null ? Visibility(
                                visible: operActive.pause != true,
                                child: SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButtonCastom(
                                        icon: Icons.do_not_disturb,
                                        text: 'Брак',//${stateWork.count}
                                        isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                        color: const Color.fromARGB(255, 222, 16, 16),
                                        onPressed: () async{
                                          String? val = '';
                                          val = await showDialog<String>(context: context,builder: (BuildContext context) => DialogInputWork(count: operActive!.list.length, indexOper: 1));
                                          
                                          if (val != '' && context.mounted) {
                                            context.read<CubitWork>().setBrak(operActive!, context.read<CubitTimer>().state.listTick[activePage], val!, true);
                                            context.read<CubitTimer>().refresh(activePage);
                                          }
                                })),
                              ) : Container(),


                              SizedBox(height: operActive.pause != true ? 8: 0),
                              operActive.pause != true ? SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButtonCastom(
                                  icon: Icons.flag,
                                  text: 'Деталь готова',
                                  // isActive: operActive.list.first.listTransfer!.length == stateWork.activeTransfer + 1 && (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                                  isActive: operActive.list.first.listTransfer!.length == stateWork.activeTransfer + 1 &&  (statusBtn == 'В работе') ,
                                  color: operActive.list.first.listTransfer!.length == stateWork.activeTransfer + 1 ? Colors.green : Colors.white70,
                                  onPressed: () async{
                                    String? val = '';
                                    val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());
                                    if (val != '' && context.mounted){
                                      context.read<CubitWork>().setReadyTransfer(operActive!, context.read<CubitTimer>().state.listTick[activePage], val!);
                                      context.read<CubitTimer>().refresh(activePage);
                                    }
                                  },
                                )) : Container(),

                          ],
                        ),
                      



                      


                      
                     
                      

                      
                      
                        
                    ],
                  )
                ) : Container(),
          ],
        ),
      );
      }
    );
  }
}