import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_input_work.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'line_text_spawn.dart';
import 'timer/timer.dart';
import 'elevated_button_castom.dart';

class ContentDetail extends StatelessWidget {
  ContentDetail(this.pageData, this.statusBtn, this.countBr, {super.key});
  final int statusBtn;
  final PageItem pageData;
  final int countBr;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    
    final userId = context.read<CubitMain>().state.user!.id;
    final astivePage = context.read<CubitWork>().state.activePage;
    final operation = pageData.operActive;
    return  operation == null
        ? const Center(
            child: Text('Нет деталей/операций на станке'),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LineTextSpawn(title: 'Деталь:', text: '${operation.list.first.batch.number} ${operation.list.first.batch.name}'),
              const SizedBox(height: 8),
              LineTextSpawn(title: 'Операция:', text: '${operation.list.first.operation.number} ${operation.list.first.operation.name}'),
              const SizedBox(height: 8),
              LineTextSpawn(title: 'Количество в опт. партии:', text: '${operation.list.length}'),
              const SizedBox(height: 8),
              Visibility(
                visible: operation.list.first.modific != null,
                child: const LineTextSpawn(title: 'Доработка:', text: 'да'),),
              const SizedBox(height: 20),
              const Time(),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 16),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButtonCastom(
                    text: 'Деталь готова',
                    isActive: (statusBtn == 0) || (statusBtn == 1),
                    color: Colors.green,
                    onPressed: () {
                      if (countBr > 0){
                        context.read<CubitWork>().setBrak(operation, userId, context.read<CubitTimer>().state.listTick[astivePage], controller.text, !(statusBtn == 1));
                      } else {
                        context.read<CubitWork>().setReady(operation, userId, context.read<CubitTimer>().state.listTick[astivePage], controller.text, !(statusBtn == 1));
                      }
                      context.read<CubitTimer>().refresh(astivePage);
                      controller.clear();
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
                              text: 'Уборка',
                              isActive: (statusBtn == 0) || (statusBtn == 2),
                              color: const Color.fromARGB(255, 40, 115, 153),
                              onPressed: () {
                                context.read<CubitWork>().setMonitor(5, userId, controller.text, !(statusBtn == 2), operation.idPath);
                                context.read<CubitTimer>().refreshAndStartStop(astivePage, !(statusBtn == 2));
                                controller.clear();
                              }))),
                  const Spacer(),
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButtonCastom(
                              text: 'Брак: $countBr',
                              isActive: (statusBtn == 0) || (statusBtn == 1),
                              color: const Color.fromARGB(255, 115, 16, 222),
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
                              text: 'Переналадка',
                              isActive: (statusBtn == 0) || (statusBtn == 3),
                              color: Colors.amber,
                              onPressed: () {
                                context.read<CubitWork>().setMonitor(3, userId, controller.text, !(statusBtn == 3), operation.idPath);
                                context.read<CubitTimer>().refreshAndStartStop(astivePage, !(statusBtn == 3));
                                controller.clear();
                              }))),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButtonCastom(
                      text: 'Поломка',
                      isActive: (statusBtn == 0) || (statusBtn == 1) || (statusBtn == 4),
                      color: Colors.red,
                      onPressed: () {
                        context.read<CubitWork>().setError(userId, context.read<CubitTimer>().state.listTick[astivePage], controller.text, !(statusBtn == 4), operation.idPath);
                        context.read<CubitTimer>().refreshAndStartStop(astivePage, !(statusBtn == 4));
                        controller.clear();
                      })),
              const SizedBox(height: 8),
              TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Комментарий')),
            ],
          );
  }
}
