import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/usecase/button_status.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_button_set.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_input_comment.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_input_work.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'line_text_spawn.dart';
import 'timer/timer.dart';
import 'elevated_button_castom.dart';

class ContentDetail extends StatelessWidget {
  const ContentDetail(this.pageData, this.statusBtn, this.countBr, {super.key});
  final String statusBtn;
  final PageItem pageData;
  final int countBr;

  @override
  Widget build(BuildContext context) {
    print(statusBtn);
    final astivePage = context.read<CubitWork>().state.activePage;
    final operation = pageData.operActive;
    // final visibl = context.read<CubitWork>().state.visibleStatus;
    return  operation == null
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Нет деталей/операций на станке'),
            const Time(true),
            const SizedBox(height: 8),
            SizedBox(
            width: double.maxFinite,
            child: ElevatedButtonCastom(
                text: 'Поломка',
                isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой') || (statusBtn == 'Поломка'),
                color: ButtonStatus().getColorStatus('Поломка'),
                onPressed: () async{
                  String? val = '';
                  if (statusBtn != 'Поломка') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
                  else{val = '-';}
                  if (val != ''){
                    // if (context.mounted) await context.read<CubitWork>().setError(context.read<CubitTimer>().state.listTick[astivePage], operation.idPath);
                    if (context.mounted) await context.read<CubitWork>().setMonitor('Поломка', val!, statusBtn != 'Поломка', -1);
                    if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'Поломка');
                  }
                })),
          ],
        )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: const Color.fromARGB(66, 236, 236, 236),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LineTextSpawn(title: 'Деталь:', text: '${operation.list.first.batch.numberRS} ${operation.list.first.batch.name}'),
                      LineTextSpawn(title: 'Операция:', text: '${operation.list.first.operation.number}.${operation.list.first.operation.name}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Переходы: '),
                          ...operation.list.first.listTransfer!.isEmpty 
                            ? [const Text('отсутствуют')] 
                            : operation.list.first.listTransfer!.map((e)=>Card(color: Colors.white10, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),child: Text('${e.code}.${e.name}'),
                      ))).toList()
                      ],),
                      LineTextSpawn(title: 'Количество в опт. партии:', text: '${operation.list.length}'),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(color: ButtonStatus().getColorStatus(statusBtn), child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(statusBtn == 'Все' ? 'Простой' : statusBtn),
                      )),
                        const SizedBox(width: 12,),
                          Visibility(
                            visible: operation.list.first.modific != null,
                            child: const Card(color: Colors.amberAccent, child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Text('Доработка'),
                            )),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Time(false),
              const SizedBox(height: 6),
              const Divider(),
              const SizedBox(height: 6),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButtonCastom(
                    text: 'Деталь готова',
                    isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой'),
                    color: Colors.green,
                    onPressed: () async{
                      String? val = '';
                      val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());
                      if (val != ''){
                        if (countBr > 0){ 
                          if (context.mounted) context.read<CubitWork>().setBrak(operation, context.read<CubitTimer>().state.listTick[astivePage], val!, !((statusBtn == 'В работе') || (statusBtn == 'Простой')));
                        } else {
                          if (context.mounted) context.read<CubitWork>().setReady(operation, context.read<CubitTimer>().state.listTick[astivePage], val!, !((statusBtn == 'В работе') || (statusBtn == 'Простой')));
                        }
                        if (context.mounted) context.read<CubitTimer>().refresh(astivePage);
                      }
                    },
                  )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButtonCastom(
                              text: 'Брак: $countBr',
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
                                          builder: (context, state) => DialogInputWork(count: operation.list.length, indexOper: 1),
                                        )
                                      ),
                                      );
                                  });
                              }))),
                              const Spacer(),
                              Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButtonCastom(
                              text: 'Выбор статуса',
                              isActive: true,
                              color: const Color.fromARGB(255, 187, 194, 197),
                              onPressed: () async{
                                // context.read<CubitWork>().toggleVisibleStatus();
                                String value = '';
                                String? comment = '';
                                value = await showDialog(context: context, builder: (context) => DialogButtonSet(statusBtn));
                                if (statusBtn != value && context.mounted) {comment = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
                                else{comment = '-';}
                                if (comment != ''){
                                  if (context.mounted) await context.read<CubitWork>().setMonitor(value, comment!, statusBtn != value, operation.idPath);
                                  if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != value);
                                }
                              }))),
                ]
              ),
              // const SizedBox(height: 30),
              // Visibility(
              //   visible: visibl,
              //   child: Card(
              //     color: const Color.fromARGB(255, 187, 194, 197),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //       children: [
              //         SizedBox(
              //                 width: double.maxFinite,
              //                 child: ElevatedButtonCastom(
              //                     text: 'Переналадка',
              //                     isActive: (statusBtn == 'Все') || (statusBtn == 'Переналадка'),
              //                     color: ButtonStatus().getColorStatus('Переналадка'),
              //                     onPressed: () async{
              //                       String? val = '';
              //                       if (statusBtn != 'Переналадка') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
              //                       else{val = '-';}
              //                       if (val != ''){
              //                         if (context.mounted) context.read<CubitWork>().setMonitor('Переналадка', val!, statusBtn != 'Переналадка', operation.idPath);
              //                         if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'Переналадка');
              //                       }
              //                       })),
              //                    const SizedBox(height: 8),
              //                     SizedBox(
              //                 width: double.maxFinite,
              //                 child: ElevatedButtonCastom(
              //                     text: 'Уборка',
              //                     isActive: (statusBtn == 'Все') || (statusBtn == 'Уборка'),
              //                     color: ButtonStatus().getColorStatus('Уборка'),
              //                     onPressed: () async{
              //                       String? val = '';
              //                       if (statusBtn != 'Уборка') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
              //                       else{val = '-';}
              //                       if (val != ''){
              //                         if (context.mounted) context.read<CubitWork>().setMonitor('Уборка', val!, statusBtn != 'Уборка', operation.idPath);
              //                         if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'Уборка');
              //                       }
              //                     })),
                     
                     
              //                     const SizedBox(height: 8),
              //                     SizedBox(
              //         width: double.maxFinite,
              //         child: ElevatedButtonCastom(
              //             text: 'Поломка',
              //             isActive: (statusBtn == 'Все') || (statusBtn == 'В работе') || (statusBtn == 'Простой') || (statusBtn == 'Поломка'),
              //             color: ButtonStatus().getColorStatus('Поломка'),
              //             onPressed: () async{
              //               String? val = '';
              //               if (statusBtn != 'Поломка') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
              //               else{val = '-';}
              //               if (val != ''){
              //                 // if (context.mounted) await context.read<CubitWork>().setError(context.read<CubitTimer>().state.listTick[astivePage], operation.idPath);
              //                 if (context.mounted) await context.read<CubitWork>().setMonitor('Поломка', val!, statusBtn != 'Поломка', operation.idPath);
              //                 if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'Поломка');
              //               }
              //             })),
              //                     const SizedBox(height: 8),
                    
              //         SizedBox(
              //         width: double.maxFinite,
              //         child: ElevatedButtonCastom(
              //             text: 'Нет УП',
              //             isActive: (statusBtn == 'Все') || (statusBtn == 'НетУП'),
              //             color: ButtonStatus().getColorStatus('НетУП'),
              //             onPressed: () async{
              //              String? val = '';
              //               if (statusBtn != 'НетУП') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
              //               else{val = '-';}
              //               if (val != ''){
              //                 if (context.mounted) await context.read<CubitWork>().setMonitor('НетУП', val!, statusBtn != 'НетУП', operation.idPath);
              //                 if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'НетУП');
              //               }
              //             })),
              //         const SizedBox(height: 8),
                    
              //         SizedBox(
              //         width: double.maxFinite,
              //         child: ElevatedButtonCastom(
              //             text: 'Нет чертежа, нет технологии',
              //             isActive: (statusBtn == 'Все') || (statusBtn == 'НетЧертеж'),
              //             color: ButtonStatus().getColorStatus('НетЧертеж'),
              //             onPressed: () async{
              //              String? val = '';
              //               if (statusBtn != 'НетЧертеж') {val = await showDialog<String>(context: context,builder: (BuildContext context) => const DialogInputComment());}
              //               else{val = '-';}
              //               if (val != ''){
              //                 if (context.mounted) await context.read<CubitWork>().setMonitor('НетЧертеж', val!, statusBtn != 'НетЧертеж', operation.idPath);
              //                 if (context.mounted) context.read<CubitTimer>().refreshAndStartStop(astivePage, statusBtn != 'НетЧертеж');
              //               }
              //             })),
              //       ],
              //      ),
              //     ),
              //   )),
            ],
          );
  }
}
