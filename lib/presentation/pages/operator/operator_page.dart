import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_work.dart';
import 'package:master_plan/presentation/pages/operator/widgets/botton_item.dart';
import 'package:master_plan/presentation/pages/operator/widgets/botton_push.dart';
import 'package:master_plan/theme/theme.dart';
// import 'package:master_plan/presentation/pages/operator/widgets/text_error.dart';
// import 'widgets/buttom_back.dart';
// import 'widgets/buttom_start.dart';


class OperatorPage extends StatelessWidget {
  const OperatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitOperator>(
      create: (context) => CubitOperator(stateMain.user!.id, stateMain.machineIdList ?? []),
      child: const ContentOperator()
    );
  }
}

class ContentOperator extends StatelessWidget {
  const ContentOperator({super.key});

  @override
  Widget build(BuildContext context) {
    // final machineList = context.read<CubitOperator>().machineIdList;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              // titleTextStyle: TextStyle(),
              title: const Text('Выйти?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.greenMaket)),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Да', style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.redMaket)),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Нет', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
              return Column(
              children: [
                const Text('Оператор'),
                Text('${state.user!.fio} / ${state.user!.unit!.number} ${state.user!.unit!.name} /\n${state.user!.area!.number} ${state.user!.area!.name} / бригада', style: const TextStyle(fontSize: 12)),
              ]);
              }),
            actions: const [],
          ),
          body:  SafeArea(
            child: Scrollbar(
              thickness: 10,
              thumbVisibility: true,
              radius: const Radius.circular(10),
              child: ListView(
                children: [Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // alignment: AlignmentDirectional.center,
                      children : [
                        SizedBox(
                          height: 600,
                          child: LayoutBuilder(
                            builder: (ctx, constraints) => GridView(
                              controller: ScrollController(),
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: constraints.maxWidth < 800 ? 2 : constraints.maxWidth < 1200 ? 3 : 4,
                                crossAxisSpacing: 16, 
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.5
                              ),
                              children: [
                                BlocBuilder<CubitOperator, StateOperator>(builder: (context, state) => ButtonItem('Монитор оператора', ()=> Navigator.pushNamed(context, '/workPage'), state.isStart)),//state.isStart && machineList.isNotEmpty
                                ButtonItem('Сменное задание', () => showDialog(context: context,builder: (BuildContext context) => const DialogWork()), true),
                                ButtonItem('Табель', () => showDialog(context: context,builder: (BuildContext context) => const DialogWork()), true),
                                ButtonItem('Расчёт сдельной ЗП', () => showDialog(context: context,builder: (BuildContext context) => const DialogWork()), true),
                              ],
                            ),
                          ),
                        ),
                      // SizedBox(height: 60),
                      SizedBox(
                        // alignment: Alignment.bottomCenter,
                        // margin: EdgeInsets.only(bottom: 10),
                        width: double.maxFinite, 
                        child: ButtonPush(),
                        )
                      ]
                    ),
                  )
                  ),]
              ),
            ),
          ),
        ),
      ),
    );
  }
}