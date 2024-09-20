import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_work.dart';
import 'package:master_plan/presentation/pages/operator/widgets/botton_item.dart';
import 'package:master_plan/presentation/pages/operator/widgets/botton_push.dart';
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
    final machineList = context.read<CubitOperator>().machineIdList;
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
            return Column(
            children: [
              const Text('Оператор'),
              Text('${state.user!.fio} / ${state.user!.position.name}', style: const TextStyle(fontSize: 12)),
            ]);
            }),
          actions: const [],
        ),
        body:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: 
            machineList.isEmpty 
            ? Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    color: Colors.red,
                    child: Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Text('Оборудование не назначено.\nОбратитесь к мастеру!', textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Image.asset('assets/images/operator/notDetails.jpg', width: 300,)
              ],
            )
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  LayoutBuilder(
                    builder: (ctx, constraints) => GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth < 1000 ? 2 : 3, 
                        crossAxisSpacing: 16, 
                        mainAxisSpacing: 16,
                        childAspectRatio: 2
                      ),
                      children: [
                        BlocBuilder<CubitOperator, StateOperator>(builder: (context, state) => ButtonItem('Монитор оператора', ()=> Navigator.pushNamed(context, '/workPage'), state.isStart && machineList.isNotEmpty)),
                        ButtonItem('Сменное задание', () => showDialog(context: context,builder: (BuildContext context) => const DialogWork()), true),
                        ButtonItem('Табель', () => showDialog(context: context,builder: (BuildContext context) => const DialogWork()), true),
                        ButtonItem('Расчёт сдельной ЗП', () => showDialog(context: context,builder: (BuildContext context) => const DialogWork()), true),
                      ],
                    ),
                  ),

                const SizedBox(width: double.maxFinite, child: ButtonPush())
                ]
              ),
            )
            ),
        ),
      ),
    );
  }
}