import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import '../../../../../domain/model/machine.dart';
import 'chief_machine_cubit/chief_machine_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_machines_list_page/chief_machine_list_widgets/edit_page_arguments.dart';

class ChiefMachineEditPage extends StatelessWidget {
  const ChiefMachineEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as EditPageArguments;
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider(
      create: (context) => ChiefMachineCubit(stateMain.controlMachineList ?? [], stateMain.shiftScheduleList ?? [], stateMain.listViewMachine ?? []),
      child: ChiefMachineEditPageView(
        machine: arguments.machineModel,
        areaId: arguments.areaId,
      ),
    );
  }
}

class ChiefMachineEditPageView extends StatefulWidget {
  const ChiefMachineEditPageView({required this.machine, required this.areaId, super.key});

  final Machine machine;
  final int areaId;

  @override
  State<ChiefMachineEditPageView> createState() => _ChiefMachineEditPageViewState();
}

class _ChiefMachineEditPageViewState extends State<ChiefMachineEditPageView> {
  @override
  void initState() {
    super.initState();
    context.read<ChiefMachineCubit>().fetchDropDownItems(selectedAreaId: widget.areaId);
    context.read<ChiefMachineCubit>().nameController.text = widget.machine.name;
    context.read<ChiefMachineCubit>().numberController.text = '${widget.machine.inventoryNumber}';
    context.read<ChiefMachineCubit>().modelController.text = widget.machine.model == null ? '' : widget.machine.model!;
    context.read<ChiefMachineCubit>().prefixController.text = widget.machine.prefix == null ? '' : widget.machine.prefix!;
    context.read<ChiefMachineCubit>().isActivated = widget.machine.isActivated;
    context.read<ChiefMachineCubit>().activeTypeMachineId = widget.machine.typeMachineId;
    context.read<ChiefMachineCubit>().activeShiftScheduleId = widget.machine.shiftScheduleId;
    context.read<ChiefMachineCubit>().activeViewId = widget.machine.viewMachineId;
    context.read<ChiefMachineCubit>().activeControlId = widget.machine.controlMachineId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('редактирование оборудования')),
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
                        decoration: InputDecoration(hintText: widget.machine.name, labelText: 'Название'),
                        controller: context.read<ChiefMachineCubit>().nameController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(hintText: '${widget.machine.inventoryNumber}', labelText: 'Инвентарный номер'),
                        controller: context.read<ChiefMachineCubit>().numberController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      //
                      TextField(
                        decoration: InputDecoration(hintText: widget.machine.model, labelText: 'Модель'),
                        controller: context.read<ChiefMachineCubit>().modelController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(hintText: widget.machine.prefix, labelText: 'Доп. название'),
                        controller: context.read<ChiefMachineCubit>().prefixController,
                      ),
                      const SizedBox(height: 10),
                      //Вид оборудования
                      const Text('Вид оборудования', style: TextStyle(fontSize: 12)),
                      DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('Вид оборудования'),
                        value: context.read<ChiefMachineCubit>().activeViewId,
                        onChanged: (int? value) => {
                          context.read<ChiefMachineCubit>().getNewlistViewMachine(value),
                          context.read<ChiefMachineCubit>().activeViewId =value ?? context.read<ChiefMachineCubit>().activeViewId,
                          setState(() {})
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
                                print(context.read<ChiefMachineCubit>().isActivated);
                                context.read<ChiefMachineCubit>().isActivated == true
                                    ? (setState(() {
                                        context.read<ChiefMachineCubit>().isActivated = !context.read<ChiefMachineCubit>().isActivated;
                                        context.read<ChiefMachineCubit>().activatedMachinesQuantity = context.read<ChiefMachineCubit>().activatedMachinesQuantity - 1;
                                      }))
                                    : ((context.read<ChiefMachineCubit>().activatedMachinesQuantity <context.read<ChiefMachineCubit>().paidMachinesQuantity)
                                        ? (setState(() {
                                            context.read<ChiefMachineCubit>().isActivated =!context.read<ChiefMachineCubit>().isActivated;
                                            context.read<ChiefMachineCubit>().activatedMachinesQuantity = context.read<ChiefMachineCubit>().activatedMachinesQuantity +1;
                                          }))
                                        : (ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('активировать невозможно\nоплатите больше рабочих мест')))));
                              })
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(child: ElevatedButton(
                        onPressed: () {
                          context.read<ChiefMachineCubit>().updateMachine(machine: widget.machine);
                          Navigator.pop(context, false);
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: const Text('оборудование изменено')));
                        },
                        child: const Text('изменить'),
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
