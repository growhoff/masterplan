import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

import 'chief_machine_cubit/chief_machine_cubit.dart';

class ChiefMachineInsertPage extends StatelessWidget {
  const ChiefMachineInsertPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider(
      create: (context) => ChiefMachineCubit(stateMain.controlMachineList ?? [], stateMain.shiftScheduleList ?? [], stateMain.listViewMachine ?? []),
      child: ChiefMachineInsertPageView(),
    );
  }
}

class ChiefMachineInsertPageView extends StatefulWidget {
  ChiefMachineInsertPageView({super.key});

  @override
  State<ChiefMachineInsertPageView> createState() => _ChiefMachineInsertPageViewState();
}

class _ChiefMachineInsertPageViewState extends State<ChiefMachineInsertPageView> {
  @override
  void initState() {
    context.read<ChiefMachineCubit>().fetchDropDownItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('добавление оборудования')),
      body: BlocBuilder<ChiefMachineCubit, ChiefMachineState>(
        builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: 'Название'),
                        controller: context.read<ChiefMachineCubit>().nameController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Инвентарный номер'),
                        controller: context.read<ChiefMachineCubit>().numberController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      //
                      TextField(
                        decoration: const InputDecoration(labelText: 'Модель'),
                        controller: context.read<ChiefMachineCubit>().modelController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Доп. название'),
                        controller: context.read<ChiefMachineCubit>().prefixController,
                      ),
                      const SizedBox(height: 10),
                      //Вид оборудования
                      const Text('Вид оборудования', style: TextStyle(fontSize: 12)),
                      DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('Вид оборудования'),
                        value: context.read<ChiefMachineCubit>().activeViewId,
                        onChanged: (int? value) {
                          context.read<ChiefMachineCubit>().getNewlistViewMachine(value);
                          context.read<ChiefMachineCubit>().activeViewId =value ?? context.read<ChiefMachineCubit>().activeViewId;
                          setState(() {});
                          },
                        items: state.listView.map((e) => DropdownMenuItem(value: e.index,child: Text(e.name))).toList(),
                      ),
                      const SizedBox(height: 10),
                      //Тип оборудования
                      const Text('Тип оборудования', style: TextStyle(fontSize: 12)),
                      DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('Тип оборудования'),
                        value: context.read<ChiefMachineCubit>().activeTypeMachineId,
                        onChanged: (int? value) => setState(() => context.read<ChiefMachineCubit>().activeTypeMachineId = value ?? context.read<ChiefMachineCubit>().activeTypeMachineId),
                        items: state.listType.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name))).toList(),
                      ),
                      const SizedBox(height: 10),
                      //Управление
                      const Text('Управление', style: TextStyle(fontSize: 12)),
                      DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('Управление'),
                        value: context.read<ChiefMachineCubit>().activeControlId,
                        onChanged: (int? value) => setState(() => context.read<ChiefMachineCubit>().activeControlId =value ?? context.read<ChiefMachineCubit>().activeControlId),
                        items: state.listControl.map((e) => DropdownMenuItem(value: e.index,child: Text(e.name))).toList(),
                      ),
                      //График
                      const Text('График', style: TextStyle(fontSize: 12)),
                      DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('График'),
                        value: context.read<ChiefMachineCubit>().activeShiftScheduleId,
                        onChanged: (int? value) => setState(() => context.read<ChiefMachineCubit>().activeShiftScheduleId =value ?? context.read<ChiefMachineCubit>().activeShiftScheduleId),
                        items: state.listShiftSch.map((e) => DropdownMenuItem(value: e.index,child: Text(e.name))).toList(),
                      ),
                      //
                      const SizedBox(height: 10),
                      const Text('Участок', style: TextStyle(fontSize: 12)),
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Участок'),
                        value: context.read<ChiefMachineCubit>().selectedArea,
                        onChanged: (String? value) => setState(() => context.read<ChiefMachineCubit>().selectedArea =value ?? context.read<ChiefMachineCubit>().selectedArea),
                        items: state.areasNamesList.map((String area) => DropdownMenuItem(value: area,child: Text(area))).toList(),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text('активировать', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Checkbox(
                              value: context.read<ChiefMachineCubit>().isActivated,
                              onChanged: (value) {
                                print(context.read<ChiefMachineCubit>().activatedMachinesQuantity);
                                print(context.read<ChiefMachineCubit>().paidMachinesQuantity);
                                (context.read<ChiefMachineCubit>().activatedMachinesQuantity < context.read<ChiefMachineCubit>().paidMachinesQuantity)
                                    ? (setState(() {context.read<ChiefMachineCubit>().isActivated = !context.read<ChiefMachineCubit>().isActivated;}))
                                    : (ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('активировать невозможно\nоплатите больше рабочих мест'))));
                              })
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(child: ElevatedButton(
                        onPressed: () {
                          bool isCreate = context.read<ChiefMachineCubit>().chekCreateMachine();
                          if (isCreate){
                            context.read<ChiefMachineCubit>().insertMachine();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: const Text('оборудование добавлено')));
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: const Text('заполнены не все поля')));
                          }
                          setState(() {});
                        },
                        child: const Text('добавить'),
                      ))
                    ],
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}
