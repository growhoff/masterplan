import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'line_text_spawn.dart';
import 'timer/timer.dart';
import 'elevated_button_castom.dart';

class ContentDetail extends StatelessWidget {
  ContentDetail(this.pageData, this.statusBtn, {super.key});
  final int statusBtn;
  final PageItem pageData;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    
    final userId = context.read<CubitMain>().state.user!.id;
    final astivePage = context.read<CubitWork>().state.activePage;
    final operation = pageData.operActive;
    return  operation == null //pageData.operQueueList.isEmpty &&
        ? const Center(
            child: Text('Нет деталей/операций на станке'),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LineTextSpawn(title: 'Деталь', text: '${operation.batch.number} ${operation.batch.name}'),
              const SizedBox(height: 8),
              LineTextSpawn(title: 'Операция', text: '${operation.operation.number} ${operation.operation.name}'),
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
                    onPressed: () => {
                            context.read<CubitWork>().setReady(operation, userId, context.read<CubitTimer>().state.listTick[astivePage], controller.text, !(statusBtn == 1)),
                            context.read<CubitTimer>().refresh(astivePage),
                            controller.clear()
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
                                context.read<CubitWork>().setMonitor(5, userId, controller.text, !(statusBtn == 2), operation.id);
                                context.read<CubitTimer>().refreshAndStartStop(astivePage, !(statusBtn == 2));
                                controller.clear();
                              }))),
                  const Spacer(),
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButtonCastom(
                              text: 'Брак',
                              isActive: true,
                              color: const Color.fromARGB(255, 115, 16, 222),
                              onPressed: () {
                                // context.read<CubitWork>().setMonitor(5, userId, controller.text, !(statusBtn == 2));
                                // context.read<CubitTimer>().refreshAndStartStop(astivePage, !(statusBtn == 2));
                                // controller.clear();
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
                                context.read<CubitWork>().setMonitor(3, userId, controller.text, !(statusBtn == 3), operation.id);
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
                        context.read<CubitWork>().setError(operation.id, userId, context.read<CubitTimer>().state.listTick[astivePage], controller.text, !(statusBtn == 4), operation.id);
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
